import SwiftUI

struct ChamferView: View {
    /// # - AppStorage
    @AppStorage("units") var units: Bool = false // MM - false ; Inch - true
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("feedback_style") var sensoryFeedbackStyle: String = "Light"
    /// # - Enums
    enum Field: Hashable {
        case depthField
        case angleField
        case depthStepsField
        case lenghtStepsField
        case repeatsField
    }
    /// # - Environments
    @Environment(\.dismiss) var dismiss
    /// # - States
    @StateObject var viewModel = ViewModel()
    @FocusState private var focusedField: Field?
    
    @State var depth = 0.0
    @State var angle = 0.0
    @State var depthSteps = 0.0
    @State var lenghtSteps = 0.0
    @State var repeats = 0
    
    @State var openSettingsView: Bool = false
    
    /// # - Formatters
    let twoDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        return formatter
    }()
    /// # - Functions
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
    func chamferRepeats() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if repeats > 1 {
                depthSteps = depth / Double(repeats)
                let angleRad = angle * Double.pi / 180.0
                let secondSide = depthSteps / tan(angleRad)
                lenghtSteps = secondSide
            } else {
                repeats = 0
                depthSteps = 0.0
                lenghtSteps = 0.0
            }
        }
    }
    func clearSections() {
        depth = 0.0
        angle = 0.0
        depthSteps = 0.0
        lenghtSteps = 0.0
        repeats = 0
    }

    var body: some View {
        let depthDyn = Binding(
            get: { depth },
            set: { depth = $0
                if $0 > 0.0 {
                    chamferRepeats()
                }
            }
        )
        let angleDyn = Binding(
            get: { angle },
            set: { angle = $0
                if $0 > 0.0 {
                    chamferRepeats()
                }
            }
        )
        let depthStepsDyn = Binding(
            get: { depthSteps },
            set: { depthSteps = $0
                if $0 > 0.0 {
                    chamferRepeats()
                }
            }
        )
        let lenghtStepsDyn = Binding(
            get: { lenghtSteps },
            set: { lenghtSteps = $0
                if $0 > 0.0 {
                    chamferRepeats()
                }
            }
        )
        let repeatsDyn = Binding(
            get: { repeats },
            set: { repeats = $0
                if $0 > 0 {
                    chamferRepeats()
                }
            }
        )

        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea(.all)
                VStack(alignment: .center) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .center) {
                            HStack {
                                Spacer()
                                Text("Chamfer size")
                                    .font(.custom("SFPro-ExpandedBold", size: 20))
                                    .foregroundColor(.white)
                                    .textCase(.uppercase)
                                    .padding(.bottom, 2.0)
                                Spacer()
                            }
                            InputComponent(name: "Size", inputName: "size", inputValue: depthDyn)
                                .focused($focusedField, equals: .depthField)
                            InputComponent(name: "Angle", inputName: "angle", inputValue: angleDyn)
                                .focused($focusedField, equals: .angleField)
                            Divider()
                            HStack {
                                Spacer()
                                Text("Instrument processing")
                                    .font(.custom("SFPro-ExpandedBold", size: 20))
                                    .foregroundColor(.white)
                                    .textCase(.uppercase)
                                    .padding(.bottom, 2.0)
                                    .padding(.top)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                VStack(alignment: .center) {
                                    HStack {
                                        Text("Number of steps")
                                            .font(.custom("SFPro-ExpandedBold", size: 20))
                                            .foregroundColor(.white)
                                            .textCase(.uppercase)
                                    }
                                    TextField("steps", value: repeatsDyn, formatter: twoDigits)
                                        .font(.custom("SFPro-Bold", size: 45))
                                        .multilineTextAlignment(.center)
                                        .padding(.top, -15)
                                        .keyboardType(.decimalPad)
                                        .onChange(of: repeats) { newValue in
                                            repeats = newValue
                                        }
                                        .font(.custom("SFPro-Bold", size: 30))
                                        .focused($focusedField, equals: .repeatsField)
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                                .padding(.horizontal, -30)
                                Spacer()
                            }
                            InputComponent(name: "Depth", inputName: "depth", inputValue: depthStepsDyn)
                                .focused($focusedField, equals: .depthStepsField)
                                .padding(.top)
                            InputComponent(name: "Lenght", inputName: "lenght", inputValue: lenghtStepsDyn)
                                .focused($focusedField, equals: .lenghtStepsField)
                        }
                        .padding([.bottom, .leading, .trailing])
                    }
                    .scrollDismissesKeyboard(.immediately)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    HStack {
                        Button("Done") {
                            hapticFeedbacker()
                            focusedField = nil
                        }
                        Button {
                            hapticFeedbacker()
                            switch focusedField {
                            case .depthField:
                                focusedField = nil
                            case .angleField:
                                focusedField = .depthField
                            case .repeatsField:
                                focusedField = .angleField
                            case .depthStepsField:
                                focusedField = .repeatsField
                            case .lenghtStepsField:
                                focusedField = .depthStepsField
                            default:
                                focusedField = nil
                            }
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        Button {
                            hapticFeedbacker()
                            switch focusedField {
                            case .depthField:
                                focusedField = .angleField
                            case .angleField:
                                focusedField = .repeatsField
                            case .repeatsField:
                                focusedField = .depthStepsField
                            case .depthStepsField:
                                focusedField = .lenghtStepsField
                            default:
                                focusedField = nil
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                    }
                }
            }
            .toolbar {
                /// # - Back button
                ToolbarButtonComp(name: "Back", color: .red, action: { dismiss()})
                /// # - Clear button
                ToolbarButtonComp(name: "Clear", color: .green, action: { clearSections() })
                /// # - Settings
                ToolbarButtonComp(name: "Settings", color: .blue, action: { openSettingsView = true })
                .sheet(isPresented: $openSettingsView) {
                    if #available(iOS 16.4, *) {
                        Settings(controller: viewModel)
                            .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                            .presentationDragIndicator(.hidden)
                            .presentationDetents([.fraction(0.7)])
                    } else {
                        Settings()
                            .presentationDragIndicator(.hidden)
                            .presentationDetents([.fraction(0.7)])
                    }
                }
            }
        }
        .onTapToDismissKeyboard()
    }
}
