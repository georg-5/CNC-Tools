import SwiftUI

struct ToolbarButtonComp: View {
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("feedback_style") var sensoryFeedbackStyle: String = "Light"
    
    @StateObject var viewModel = ViewModel()
    
    var name: String
    var color: Color
    var action: () -> ()
    
    func hapticFeedbacker() {
        if sensoryFeedback {
            switch sensoryFeedbackStyle {
            case viewModel.hapticStyleArray[0]:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case viewModel.hapticStyleArray[1]:
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            case viewModel.hapticStyleArray[2]:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case viewModel.hapticStyleArray[3]:
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            case viewModel.hapticStyleArray[4]:
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            default:
                break
            }
        }
    }
    
    init(name: String, color: Color, action: @escaping () -> Void) {
        self.name = name
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                action()
                hapticFeedbacker()
            }
        } label: {
            Text(name)
                .font(.custom("SFPro-Bold", size: 10))
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal)
                .background(Capsule()
                    .foregroundColor(color))
        }
    }
}

#Preview {
    ToolbarButtonComp(name: "Back", color: .orange, action: {})
}
