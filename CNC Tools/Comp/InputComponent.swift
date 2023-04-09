import SwiftUI

struct InputComponent: View {
    // MARK: - VARIABLES
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
                        .font(.custom("SpaceMono-Regular", size: 20))
                    Spacer()
                }
                TextField(inputName, value: $inputValue, formatter: twoDigits)
                    .padding(.top, -22.0)
                    .keyboardType(.decimalPad)
                    .onChange(of: inputValue) { newValue in
                        inputValue = newValue
                    }
                    .font(.custom("SpaceMono-Bold", size: 28))
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
