import { AppStorageV2 } from "@kit.ArkUI";
import { LoginStateManager } from "../utils/LoginStateManager";

// 必须导出 Builder，对应 route_map.json 中的 buildFunction
@Builder
export function loginBuilder() {
  login();
}

@Component
struct login {
  // 1. 核心：连接全局路由栈 (逻辑保持不变)
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack')!;

  // 2. 页面 UI 状态
  @State phoneNumber: string = '';
  @State password: string = '';
  @State isAgreed: boolean = false; // 是否勾选协议

  // 大麦风格的主色调
  private readonly damaiGradient: LinearGradient = new LinearGradient([
    { color: "#FF4E6D", offset: 0 }, // 玫红
    { color: "#FF8B3D", offset: 1 }  // 橙色
  ])

  build() {
    NavDestination() {
      Column() {
        // --- 1. 顶部导航栏 (关闭按钮 + 帮助) ---
        Row() {
          // 关闭/返回按钮
          Image($r('app.media.guanbi')) // 如果没有这个图标，可以用 Text("✕") 代替
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              this.pathStack.pop();
            })
            // 如果图片资源不存在，用文字兜底，防止留白
            .overlay("✕", { align: Alignment.Center })

          Blank()

          Text("帮助")
            .fontSize(14)
            .fontColor("#333333")
        }
        .width('100%')
        .height(50)
        .padding({ left: 20, right: 20 })
        .alignItems(VerticalAlign.Center)

        // --- 2. 标题区域 ---
        Column() {
          Text("密码登录")
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor("#111111")
            .margin({ bottom: 10 })

          Text("欢迎来到大麦")
            .fontSize(14)
            .fontColor("#999999")
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding({ left: 30, top: 20, bottom: 40 })

        // --- 3. 输入框区域 ---
        Column({ space: 20 }) {
          // 账号输入框
          Column() {
            TextInput({ text: this.phoneNumber, placeholder: '请输入手机号/邮箱' })
              .placeholderColor("#CCCCCC")
              .fontSize(16)
              .caretColor("#FF2D79") // 光标颜色
              .backgroundColor(Color.Transparent) // 透明背景
              .padding({ left: 0 }) // 靠左
              .onChange((value) => { this.phoneNumber = value })
              .height(40)

            // 底部线条
            Divider().color("#EEEEEE").strokeWidth(1)
          }

          // 密码输入框
          Column() {
            TextInput({ text: this.password, placeholder: '请输入登录密码' })
              .type(InputType.Password)
              .placeholderColor("#CCCCCC")
              .fontSize(16)
              .caretColor("#FF2D79")
              .backgroundColor(Color.Transparent)
              .padding({ left: 0 })
              .onChange((value) => { this.password = value })
              .height(40)

            Divider().color("#EEEEEE").strokeWidth(1)
          }
        }
        .padding({ left: 30, right: 30 })
        .margin({ bottom: 40 })

        // --- 4. 登录按钮 ---
        Button("登录")
          .width('85%')
          .height(50)
          // 渐变色背景
          .linearGradient({
            angle: 90,
            colors: [[0xFF4E6D, 0.0], [0xFF8B3D, 1.0]]
          })
          .shadow({ radius: 10, color: 'rgba(255, 78, 109, 0.3)', offsetY: 5 })
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            // 这里可以加简单的校验，例如：
            // if (this.phoneNumber === '' || this.password === '') {
            //   promptAction.showToast({ message: '请输入账号密码' });
            //   return;
            // }

            // 执行原有逻辑
            await LoginStateManager.login();

            // 返回
            this.pathStack.pop();
          })

        // --- 5. 协议勾选 & 找回密码 ---
        Row() {
          Checkbox({ name: 'agreement', group: 'login' })
            .select(this.isAgreed)
            .selectedColor("#FF2D79")
            .width(16)
            .height(16)
            .onChange((val) => { this.isAgreed = val })

          Text() {
            Span("我已阅读并同意 ")
            Span("《用户协议》").fontColor("#FF2D79")
            Span(" 和 ")
            Span("《隐私政策》").fontColor("#FF2D79")
          }
          .fontSize(11)
          .fontColor("#999999")
          .margin({ left: 5 })
        }
        .width('85%')
        .margin({ top: 15 })
        .justifyContent(FlexAlign.Start)

        Row() {
          Text("找回密码")
            .fontSize(13)
            .fontColor("#666666")
          Text(" | ")
            .fontColor("#DDDDDD")
          Text("短信快捷登录")
            .fontSize(13)
            .fontColor("#666666")
        }
        .margin({ top: 20 })


        Blank() // 撑开空间，把下方内容推到底部

        // --- 6. 底部第三方登录 ---
        Column() {
          Text("其他登录方式")
            .fontSize(12)
            .fontColor("#CCCCCC")
            .margin({ bottom: 20 })

          Row({ space: 40 }) {
            // 微信
            this.SocialIcon("#09BB07", "微信")
            // QQ
            this.SocialIcon("#4CA6FF", "QQ")
            // 微博
            this.SocialIcon("#E6162D", "微博")
          }
        }
        .margin({ bottom: 50 }) // 距离底部的距离
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
    }
    .hideTitleBar(true)
  }

  // 封装一个小组件用来画底部的圆球图标
  @Builder
  SocialIcon(color: string, text: string) {
    Column() {
      // 模拟图标，实际开发换成 Image($r('app.media.wechat'))
      Circle({ width: 44, height: 44 })
        .fill(Color.White)
        .stroke(color)
        .strokeWidth(1)
        .overlay(text.substring(0, 1), { align: Alignment.Center }) // 显示首字代替图标

      Text(text)
        .fontSize(10)
        .fontColor("#999999")
        .margin({ top: 6 })
    }
  }
}
