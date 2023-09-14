import SwiftUI

struct InputComponent: View {
    /// # - AppStorage
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("feedback_style") var sensoryFeedbackStyle: String = "Light"
    /// # - States
    @State var textFieldFilled: Bool = false
    
    /// # - Variables
    var name: String
    var inputName: String
    /// # - Bindings
    @Binding var inputValue: Double
    /// # - Init
    init(name: String, inputName: String, inputValue: Binding<Double>) {
        self.name = name
        self.inputName = inputName
        _inputValue = inputValue
    }
    /// # - Formatter
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
            Spacer()
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Text(name)
                        .font(.custom("SFPro-ExpandedLight", size: 17))
                        .textCase(.uppercase)
                    Spacer()
                }
                HStack {
                    Spacer()
                    TextField(inputName, value: $inputValue, formatter: twoDigits)
                        .font(.custom("SFPro-Bold", size: 45))
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .onChange(of: inputValue) { newValue in
                            hapticFeedbacker()
                        }
                        .padding(.top, -8)
                    Spacer()
                }
            }
            .foregroundStyle(.white)
            .padding(.vertical, 5.0)
            Spacer()
        }
    }
}
