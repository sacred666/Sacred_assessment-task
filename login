import { promptAction } from "@kit.ArkUI";
import { UserApi } from "../api/UserApi";
import { NavUtils } from "../utils/NavUtils";
import { LoginRequest } from "../model/UserModel";

@Builder export function loginBuilder() { Login(); }

@Component
struct Login {
  @StorageLink('GlobalStack') pathStack: NavPathStack = new NavPathStack();
  @State isLoginMode: boolean = true;
  @State isRequesting: boolean = false; // 防连击

  // 表单状态变量
  @State account: string = 'qiushuiling';
  @State password: string = '123456';
  @State userName: string = '';
  @State email: string = '';
  @State isAgreed: boolean = false;

  build() {
    NavDestination() {
      Column() {
        Row() {
          Image($r('app.media.back')).width(24).height(24).onClick(() => { NavUtils.pop(); })
          Blank()
          Text("帮助").fontSize(14).fontColor("#333")
        }.width('100%').height(50).padding({ left: 16, right: 16 })

        Column() {
          Text(this.isLoginMode ? "账号密码登录" : "新用户注册").fontSize(28).fontWeight(FontWeight.Bold).margin({ bottom: 8 })
          Text("欢迎来到大麦").fontSize(14).fontColor("#999")
        }.width('100%').alignItems(HorizontalAlign.Start).padding({ left: 30, top: 20, bottom: 40 })

        Column({ space: 20 }) {
          if (!this.isLoginMode) {
            Column() {
              TextInput({ text: this.userName, placeholder: '请输入昵称 (如: 麦子)' })
                .fontSize(16).backgroundColor(Color.Transparent).height(40)
                .onChange((v) => this.userName = v)
              Divider().color("#EEE")
            }
            Column() {
              TextInput({ text: this.email, placeholder: '请输入邮箱 (如: a@qq.com)' })
                .fontSize(16).backgroundColor(Color.Transparent).height(40)
                .onChange((v) => this.email = v)
              Divider().color("#EEE")
            }
          }

          Column() {
            // 【关键提示】提醒你注册时必须要改这个 account 字段
            TextInput({ text: this.account, placeholder: this.isLoginMode ? '请输入登录账号' : '设置登录账号(英文字母，必须唯一!)' })
              .fontSize(16).backgroundColor(Color.Transparent).height(40)
              .onChange((v) => this.account = v)
            Divider().color("#EEE")
          }
          Column() {
            TextInput({ text: this.password, placeholder: this.isLoginMode ? '请输入密码' : '请设置密码' })
              .type(InputType.Password).fontSize(16).backgroundColor(Color.Transparent).height(40)
              .onChange((v) => this.password = v)
            Divider().color("#EEE")
          }
        }.padding({ left: 30, right: 30 })

        Row() {
          Checkbox().select(this.isAgreed).selectedColor("#FF2D79").width(18)
            .onChange((v) => this.isAgreed = v)
          Text("我已阅读并同意《用户协议》").fontSize(12).margin({ left: 8 }).fontColor("#999")
        }.width('100%').padding({ left: 30, right: 30 }).margin({ top: 15, bottom: 25 })

        Button(this.isRequesting ? "处理中..." : (this.isLoginMode ? "登录" : "立即注册"))
          .width('85%').height(50)
          .linearGradient(this.isRequesting ? { angle: 90, colors: [['#CCCCCC', 0.0],['#999999', 1.0]] } : { angle: 90, colors: [[0xFF4E6D, 0.0],[0xFF8B3D, 1.0]] })
          .enabled(!this.isRequesting)
          .onClick(async () => {
            if (this.isRequesting) return;
            if (!this.isAgreed) { promptAction.showToast({ message: '请先勾选协议' }); return; }
            if (!this.account.trim() || !this.password.trim()) { promptAction.showToast({ message: '账号和密码不能为空' }); return; }

            this.isRequesting = true;

            try {
              // 【核心修复】无论是登录还是注册，全都传满 6 个字段，完全一比一复刻你的 cURL
              let payload: LoginRequest = {
                account: this.account.trim(),
                password: this.password.trim(),
                type: this.isLoginMode ? 2 : 1,
                name: this.userName.trim() || (this.isLoginMode ? "默认用户" : "新用户"),
                email: this.email.trim() || (this.isLoginMode ? "default@qq.com" : "register@qq.com"),
                image: "https://damai2802.oss-cn-hangzhou.aliyuncs.com/images/2026/02/24/937993a20c4340f69fc8149283bfdbcc.jpg"
              };

              const success = await UserApi.login(payload);
              if (success) {
                if (this.isLoginMode) {
                  NavUtils.pop();
                } else {
                  promptAction.showToast({ message: '注册成功，请登录' });
                  this.isLoginMode = true;
                }
              }
            } finally {
              this.isRequesting = false;
            }
          })

        Text(this.isLoginMode ? "没有账号？点击注册" : "已有账号？去登录")
          .fontSize(14).fontColor("#FF2D79").margin({ top: 20 })
          .onClick(() => {
            if (this.isRequesting) return;
            this.isLoginMode = !this.isLoginMode;
            if (!this.isLoginMode) {
              // 切换注册时清空，防止误用旧账号
              this.account = '';
              this.password = '';
              this.userName = '';
              this.email = '';
            } else {
              this.account = 'qiushuiling';
              this.password = '123456';
            }
          })

        Blank()
      }.width('100%').height('100%').backgroundColor(Color.White)
    }.hideTitleBar(true)
  }
}
