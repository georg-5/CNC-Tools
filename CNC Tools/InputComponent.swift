import SwiftUI

struct InputComponent: View {
    var name = "Tool"
    var inputName = "Text"
    @State var inputValue = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .font(.custom("SFPro-ExpandedRegular", size: 22))
                Spacer()
            }
            TextField("\(name)", value: $inputValue, format: .number)
                .font(.custom("SFPro-ExpandedSemiBold", size: 28))
        }
    }
}

struct InputComponent_Previews: PreviewProvider {
    static var previews: some View {
        InputComponent()
    }
}
