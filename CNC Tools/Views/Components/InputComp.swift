import SwiftUI

struct InputComponent: View {

    var name: String
    var inputName: String
    @Binding var inputValue: Double
    
    // MARK: - INIT
    init(name: String, inputName: String, inputValue: Binding<Double>) {
        self.name = name
        self.inputName = inputName
        _inputValue = inputValue
    }
    
    // MARK: - FORMATTER
    let twoDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        return formatter
    }()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.blue)
                    Spacer()
                }
                TextField(inputName, value: $inputValue, formatter: twoDigits)
                    .padding(.top, -15)
                    .keyboardType(.decimalPad)
                    .onChange(of: inputValue) { newValue in
                        inputValue = newValue
                    }
                    .font(.system(size: 44, weight: .bold))
            }
        }
    }
}

struct InputComponent_Previews: PreviewProvider {
    static var previews: some View {
        InputComponent(name: "Name",
                       inputName: "Input name",
                       inputValue: .constant(0.0))
            .padding()
    }
}
