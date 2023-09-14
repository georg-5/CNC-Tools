import SwiftUI

struct TrigInputComponent: View {
    /// # - AppStorage
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("feedback_style") var sensoryFeedbackStyle: String = "Light"
    /// # - Variables
    var name: String
    var inputName: String
    /// # - Bindings
    @Binding var inputValue: Double
    /// # - Inits
    init(name: String, inputName: String, inputValue: Binding<Double>) {
        self.name = name
        self.inputName = inputName
        _inputValue = inputValue
    }
    /// # - Formatters
    let twoDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        return formatter
    }()
    /// # - Environments
    @Environment(\.colorScheme) var colorScheme
    /// # - States
    @StateObject var controller = ViewModel()
    /// # - Functions
    private func hapticFeedbacker() {
        if sensoryFeedback {
            switch sensoryFeedbackStyle {
            case controller.hapticStyleArray[0]:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case controller.hapticStyleArray[1]:
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            case controller.hapticStyleArray[2]:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case controller.hapticStyleArray[3]:
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            case controller.hapticStyleArray[4]:
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            default:
                break
            }
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.custom("SFPro-ExpandedLight", size: 17))
                    .textCase(.uppercase)
                    .foregroundStyle(colorScheme == .light ? Color.black : Color.white)
                TextField(inputName, value: $inputValue, formatter: twoDigits)
                    .font(.custom("SFPro-Bold", size: 45))
                    .multilineTextAlignment(.leading)
                    .keyboardType(.decimalPad)
                    .onChange(of: inputValue) { newValue in
                        inputValue = newValue
                        hapticFeedbacker()
                    }
                    .padding(.top, -8)
            }
            .padding(.vertical, 5.0)
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
