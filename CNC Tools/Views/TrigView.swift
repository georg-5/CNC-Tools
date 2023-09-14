import SwiftUI

struct TrigView: View {
    /// # - AppStorage
    @AppStorage("units") var units: Bool = false // MM - false ; Inch - true
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("feedback_style") var sensoryFeedbackStyle: String = "Light"
    /// # - Enums
    enum Field: Hashable {
        case aSideField
        case bSideField
        case cSideField
        case aDegField
        case cDegField
    }
    /// # - Environments
    @Environment(\.dismiss) var dismiss
    /// # - States
    @StateObject var viewModel = ViewModel()
    @FocusState private var focusedField: Field?
    
    @State var aSide = 0.0
    @State var bSide = 0.0
    @State var cSide = 0.0
    @State var aDeg = 0.0
    @State var bDeg = 90.0
    @State var cDeg = 0.0
    @State var area = 0.0
    @State var perimeter = 0.0
    
    @State var openSettingsView: Bool = false
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
    func nonNumberShield() {
        if cSide < aSide {
            bSide = 0.0
            aDeg = 0.0
            bDeg = 0.0
            cDeg = 0.0
        } else if aDeg > 90.0 || cDeg > 90.0 {
            aDeg = 45.0
            bDeg = 90.0
            cDeg = 45.0
        }
    }

    // A Degrees formula
    func funcADeg() {
        nonNumberShield()
        aDeg = aSide / cSide
        aDeg = asin(aDeg)
        aDeg = aDeg * 180.0 / Double.pi
    }
    func funcADegReturn() {
        let aRad = aDeg * Double.pi / 180.0
        cSide = aSide / sin(aRad)
    }
    // C Degrees formula
    func funcCDeg() {
        nonNumberShield()
        cDeg = 180.0 - bDeg - aDeg
    }

    // A Side formula
    func funcASide() {
        nonNumberShield()
        aSide = pow(cSide, 2) - pow(bSide, 2)
        aSide = sqrt(aSide)
    }
    // B Side formula
    func funcBSide() {
        nonNumberShield()
        bSide = pow(cSide, 2) - pow(aSide, 2)
        bSide = sqrt(bSide)
    }
    // C Side formula
    func funcCSide() {
        nonNumberShield()
        cSide = pow(aSide, 2) + pow(bSide, 2)
        cSide = sqrt(cSide)
    }
    // Area calculating
    func funcArea() {
        area = 1/2 * aSide * bSide
    }
    // Perimeter calculating
    func funcPerimeter() {
        perimeter = aSide + bSide + cSide
    }
    
    private func clearSections() {
        withAnimation(.easeIn(duration: 0.3)) {
            aSide = 0.0
            bSide = 0.0
            cSide = 0.0
            aDeg = 0.0
            bDeg = 90.0
            cDeg = 0.0
            area = 0.0
            perimeter = 0.0
        }
    }

    var body: some View {
        let sideA = Binding(
            get: { aSide },
            set: { aSide = $0
                if $0 > 0.0 {
                    bDeg = 90.0
                    funcCSide()
                    funcBSide()
                    funcASide()
                    funcADeg()
                    funcCDeg()
                    funcPerimeter()
                    funcArea()
                }
            }
        )
        let sideB = Binding(
            get: { bSide },
            set: { bSide = $0
                if $0 > 0.0 {
                    bDeg = 90.0
                    funcCSide()
                    funcASide()
                    funcBSide()
                    funcADeg()
                    funcCDeg()
                    funcPerimeter()
                    funcArea()
                }
            }
        )
        let sideC = Binding(
            get: { cSide },
            set: { cSide = $0
                if $0 > 0.0 {
                    bDeg = 90.0
                    funcBSide()
                    funcCSide()
                    funcASide()
                    funcADeg()
                    funcCDeg()
                    funcPerimeter()
                    funcArea()
                }
            }
        )
        let degA = Binding(
            get: { aDeg },
            set: { aDeg = $0
                if $0 > 0.0 {
                    bDeg = 90.0
                    funcCDeg()
                    funcADegReturn()
                    funcBSide()
                    funcASide()
                    funcCSide()
                    funcPerimeter()
                    funcArea()
                }
            }
        )
        let degC = Binding(
            get: { cDeg },
            set: { cDeg = $0
                if $0 > 0.0 {
                    bDeg = 90.0
                    funcADeg()
                    aDeg = 180.0 - bDeg - cDeg
                    funcBSide()
                    funcASide()
                    funcCSide()
                    funcPerimeter()
                    funcArea()
                }
            }
        )

        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack(alignment: .top) {
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Sides")
                                    .font(.custom("SFPro-ExpandedBold", size: 20))
                                    .foregroundColor(.white)
                                    .textCase(.uppercase)
                                    .padding(.bottom, 2.0)
                                TrigInputComponent(name: "Base", inputName: "A", inputValue: sideA)
                                    .focused($focusedField, equals: .aSideField)
                                TrigInputComponent(name: "Height", inputName: "B", inputValue: sideB)
                                    .focused($focusedField, equals: .bSideField)
                                TrigInputComponent(name: "Hypotenuse", inputName: "C", inputValue: sideC)
                                    .focused($focusedField, equals: .cSideField)
                                    .padding(.bottom)
                            }
                            VStack(alignment: .leading) {
                                Text("Angles")
                                    .font(.custom("SFPro-ExpandedBold", size: 20))
                                    .foregroundColor(.white)
                                    .textCase(.uppercase)
                                    .padding(.bottom, 2.0)
                                TrigInputComponent(name: "Alpha", inputName: "α", inputValue: degA)
                                    .focused($focusedField, equals: .aDegField)
                                TrigInputComponent(name: "Gamma", inputName: "γ", inputValue: degC)
                                    .focused($focusedField, equals: .cDegField)
                                    .padding(.bottom)
                            }
                            Spacer()
                        }
                        if aSide > 0.0 && bSide > 0.0 {
                            Divider()
                            HStack(alignment: .top) {
                                Spacer()
                                VStack(alignment: .center) {
                                    Text("Area")
                                        .font(.custom("SFPro-ExpandedLight", size: 17))
                                        .textCase(.uppercase)
                                        .foregroundColor(.white)
                                        .foregroundStyle(Color.orange)
                                    Text("\(area.removeZerosFromEnd())")
                                        .font(.custom("SFPro-Bold", size: 45))
                                        .multilineTextAlignment(.leading)
                                        .keyboardType(.decimalPad)
                                        .padding(.top, -8)
                                    Text("Perimeter")
                                        .textCase(.uppercase)
                                        .font(.custom("SFPro-ExpandedLight", size: 17))
                                        .foregroundColor(.white)
                                        .padding(.top)
                                    Text("\(perimeter.removeZerosFromEnd())")
                                        .font(.custom("SFPro-Bold", size: 45))
                                        .multilineTextAlignment(.leading)
                                        .keyboardType(.decimalPad)
                                        .padding(.top, -8)
                                }
                                .padding(.vertical, 5.0)
                                Spacer()
                            }
                            .padding(.leading, 10)
                            .padding(.vertical)
                        }
                        Spacer()
                    }
                    .scrollDismissesKeyboard(.immediately)
                }
                .padding(.horizontal)
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
                            case .aSideField:
                                focusedField = nil
                            case .bSideField:
                                focusedField = .aSideField
                            case .cSideField:
                                focusedField = .bSideField
                            case .aDegField:
                                focusedField = .cSideField
                            case .cDegField:
                                focusedField = .aDegField
                            default:
                                focusedField = nil
                            }
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        Button {
                            hapticFeedbacker()
                            switch focusedField {
                            case .aSideField:
                                focusedField = .bSideField
                            case .bSideField:
                                focusedField = .cSideField
                            case .cSideField:
                                focusedField = .aDegField
                            case .aDegField:
                                focusedField = .cDegField
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
                HStack(alignment: .center) {
                    /// # - Back button
                    ToolbarButtonComp(name: "Back", color: .red, action: { dismiss()})
                    /// # - Clear button
                    ToolbarButtonComp(name: "Clear", color: .green, action: { clearSections()  })
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
        }
        .onTapToDismissKeyboard()
    }
}
