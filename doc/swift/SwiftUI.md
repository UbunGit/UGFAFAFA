## Binding
### 1. 使用“PreviewProvider”查看视图传入Binding类型值使用constant
```
struct CardView: View {
    @Binding var show: Bool
      var body: some View {
          Image(systemName: "info.circle").foregroundColor(.white)
                    .onTapGesture {
                        show.toggle()
                    }
      }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(show: .constant(false))
    }
}
```

