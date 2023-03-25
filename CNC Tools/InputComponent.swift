import SwiftUI

struct InputComponent: View {
    var name: String
    var inputName: String
    @Binding var inputValue: Double
    var inputFormatter: Formatter
    
    init(name: String, inputName: String, inputValue: Binding<Double>, inputFormatter: Formatter) {
        self.name = name
        self.inputName = inputName
        _inputValue = inputValue
        self.inputFormatter = inputFormatter
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .font(.custom("SFPro-ExpandedRegular", size: 22))
                Spacer()
            }
            TextField("\(inputName)", value: $inputValue, formatter: inputFormatter)
                .keyboardType(.decimalPad)
                .padding(.top, -10.0)
                .padding(.bottom, 10.0)
                .font(.custom("SFPro-ExpandedSemiBold", size: 28))
        }
    }
}
