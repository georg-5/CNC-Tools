import SwiftUI

struct TrigInputComponent: View {

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
            VStack(alignment: .center) {
                Text(name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.blue)
                TextField(inputName, value: $inputValue, formatter: twoDigits)
                    .padding(.top, -15)
                    .keyboardType(.decimalPad)
                    .onChange(of: inputValue) { newValue in
                        inputValue = newValue
                    }
                    .font(.system(size: 27, weight: .bold))
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct TrigInputComponent_Previews: PreviewProvider {
    static var previews: some View {
        TrigInputComponent(name: "Name",
                       inputName: "Input name",
                       inputValue: .constant(0.0))
            .padding()
    }
}
