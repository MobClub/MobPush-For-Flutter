@Entry
@Component
struct PageA {
  @State message: string = 'PAGE A';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .backgroundColor(Color.Gray)
    }
    .height('100%')
  }
}