import SwiftUI

struct InputComponent: View {
    var name: String
    var inputName: String
    @Binding var inputValue: Double
    @State private var number: NSNumber? = 0
    
    init(name: String, inputName: String, inputValue: Binding<Double>) {
        self.name = name
        self.inputName = inputName
        _inputValue = inputValue
    }

    private func formattedNumber(from input: Double) -> String {
        let components = "\(input)".split(separator: ".")
        if components.count == 2, let integerPart = components.first, let decimalPart = components.last {
            if decimalPart == "0" {
                return String(integerPart)
            } else {
                return "\(integerPart).\(decimalPart)"
            }
            } else {
                return "\(input)"
            }
        }
    private let twoDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        return formatter
     }()
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .font(.custom("SFPro-ExpandedRegular", size: 22))
                Spacer()
            }
            TextField(inputName, value: $inputValue, formatter: twoDigits)
                .keyboardType(.decimalPad)
                .onChange(of: number) { newValue in
                    if let doubleValue = newValue?.doubleValue {
                        inputValue = doubleValue
                        }
                    }
                .padding(.top, -10.0)
                .padding(.bottom, 10.0)
                .font(.custom("SFPro-ExpandedSemiBold", size: 28))
        }
    }
}

struct InputComponent_Previews: PreviewProvider {
    static var previews: some View {
        InputComponent(name: "Введите число",
                       inputName: "Число",
                       inputValue: .constant(0.0))
            .padding()
    }
}
