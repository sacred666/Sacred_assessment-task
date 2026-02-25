import { promptAction } from "@kit.ArkUI";
import { UserApi } from "../api/UserApi";
import { NavUtils } from "../utils/NavUtils";

@Builder export function loginBuilder() { Login(); }

@Component
struct Login {
  @StorageLink('GlobalStack') pathStack: NavPathStack = new NavPathStack();

  // 根据你的要求，这里可以写死一些默认值，也可以手填
  @State account: string = 'qiushuiling';
  @State password: string = '123456';
  @State isAgreed: boolean = false;

  build() {
    NavDestination() {
      Column() {
        Row() {
          Image($r('app.media.back')).width(24).height(24).onClick(()=>{ NavUtils.pop(); })
          Blank()
          Text("帮助").fontSize(14).fontColor("#333")
        }.width('100%').height(50).padding({ left: 16, right: 16 })

        Column() {
          Text("密码登录").fontSize(28).fontWeight(FontWeight.Bold).fontColor("#111").margin({ bottom: 8 })
          Text("欢迎来到大麦").fontSize(14).fontColor("#999")
        }.width('100%').alignItems(HorizontalAlign.Start).padding({ left: 30, top: 20, bottom: 40 })

        Column({ space: 20 }) {
          Column() {
            TextInput({ text: this.account, placeholder: '请输入账号' }).placeholderColor("#CCC").fontSize(16).backgroundColor(Color.Transparent).padding({ left: 0 }).onChange((v) => this.account = v).height(40)
            Divider().color("#EEE").strokeWidth(1)
          }
          Column() {
            TextInput({ text: this.password, placeholder: '请输入登录密码' }).type(InputType.Password).placeholderColor("#CCC").fontSize(16).backgroundColor(Color.Transparent).padding({ left: 0 }).onChange((v) => this.password = v).height(40)
            Divider().color("#EEE").strokeWidth(1)
          }
        }.padding({ left: 30, right: 30 })

        Row() {
          Checkbox({ name: 'agree', group: 'login' }).select(this.isAgreed).selectedColor("#FF2D79").width(18).height(18).onChange((v) => this.isAgreed = v)
          Text() { Span("我已阅读并同意《用户协议》").fontColor("#999") }.fontSize(12).margin({ left: 8 }).layoutWeight(1)
        }.width('100%').padding({ left: 30, right: 30 }).margin({ top: 15, bottom: 25 }).alignItems(VerticalAlign.Top)

        Button("登录").width('85%').height(50).linearGradient({ angle: 90, colors: [[0xFF4E6D, 0.0],[0xFF8B3D, 1.0]] }).fontSize(18).fontWeight(FontWeight.Bold)
          .onClick(async () => {
            if (!this.account || !this.password) { promptAction.showToast({ message: '请输入账号密码' }); return; }
            if (!this.isAgreed) { promptAction.showToast({ message: '请勾选协议' }); return; }

            // 【匹配后端数据】
            const success = await UserApi.login({
              name: "仇水灵",
              account: this.account,
              password: this.password,
              email: "llyz_16@qq.com",
              image: "https://damai2802.oss-cn-hangzhou.aliyuncs.com/images/2026/02/24/937993a20c4340f69fc8149283bfdbcc.jpg",
              type: 2
            });

            if (success) NavUtils.pop();
          })

        Blank()
      }
      .width('100%').height('100%').backgroundColor(Color.White)
    }.hideTitleBar(true)
  }
}
