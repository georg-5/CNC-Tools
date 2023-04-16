import SwiftUI
import GoogleMobileAds

struct TriangleView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFPro-ExpandedMedium", size: 34)!]
        }
    
    // MARK: - VARIABLES
    @FocusState private var focusedField: Field?
    @State private var trigChoose = true // true - rectangular, false - equilateral
    @State private var a = 0.0
    @State private var b = 0.0
    @State private var c = 0.0
    @State private var alpha = 0.0
    @State private var beta = 0.0
    @State private var gamma = 0.0
    
    // MARK: - ENUMS
    enum Field: Hashable {
        case aSideField
        case bSideField
        case cSideField
        case alphaField
        case betaField
        case gammaField
    }

    func caseAB() {
        c = sqrt((a * a) + (b * b))
        alpha = atan(a / b) * 180.0 / Double.pi
        beta = atan(b / a) * 180.0 / Double.pi
        gamma = 90.0
    }

    func caseAC() {
        b = sqrt((c * c) - (a * a))
        alpha = asin(a / c) * 180.0 / Double.pi
        beta = acos(a / c) * 180.0 / Double.pi
        gamma = 90.0
    }

    func caseBC() {
        a = sqrt((c * c) - (b * b))
        alpha = acos(b / c) * 180.0 / Double.pi
        beta = asin(b / c) * 180.0 / Double.pi
        gamma = 90.0
    }

    func caseAAlpha() {
        beta = 90.0 - alpha
        gamma = 90.0
        b = a * tan(alpha * Double.pi / 180.0)
        c = a / cos(alpha * Double.pi / 180.0)
    }

    func caseABeta() {
        alpha = 90.0 - beta
        gamma = 90.0
        b = a / tan(beta * Double.pi / 180.0)
        c = a / cos(beta * Double.pi / 180.0)
    }

    func caseBAlpha() {
        beta = 90.0 - alpha
        gamma = 90.0
        a = b / tan(alpha * Double.pi / 180.0)
        c = b / sin(alpha * Double.pi / 180.0)
    }

    func caseBBeta() {
        alpha = 90.0 - beta
        gamma = 90.0
        a = b * tan(beta * Double.pi / 180.0)
        c = b / sin(beta * Double.pi / 180.0)
    }

    func caseCAlpha() {
        beta = 90.0 - alpha
        gamma = 90.0
        a = c * cos(alpha * Double.pi / 180.0)
        b = c * sin(alpha * Double.pi / 180.0)
    }

    func caseCBeta() {
        alpha = 90.0 - beta
        gamma = 90.0
        a = c * sin(beta * Double.pi / 180.0)
        b = c * cos(beta * Double.pi / 180.0)
    }

    func Rectangular() {
        if a > 0.0 && b > 0.0 { caseAB() }
        else if a > 0.0 && c > 0.0 { caseAC() }
        else if b > 0.0 && c > 0.0 { caseBC() }
        else if a > 0.0 && alpha > 0.0 && alpha < 90.0 { caseAAlpha() }
        else if a > 0.0 && beta > 0.0 && beta < 90.0 { caseABeta() }
        else if b > 0.0 && alpha > 0.0 && alpha < 90.0 { caseBAlpha() }
        else if b > 0.0 && beta > 0.0 && beta < 90.0 { caseBBeta() }
        else if c > 0.0 && alpha > 0.0 && alpha < 90.0 { caseCAlpha() }
        else if c > 0.0 && beta > 0.0 && beta < 90.0 { caseCBeta() }
    }


    




    var body: some View {
        let aSide = Binding (
            get: { a },
            set: { a = $0
                if $0 > 0.0 {
                    Rectangular()
                }
            }
        )
        let bSide = Binding (
            get: { b },
            set: { b = $0
                if $0 > 0.0 {
                    Rectangular()
                }
            }
        )
        let cSide = Binding (
            get: { c },
            set: { c = $0
                if $0 > 0.0 {
                    if trigChoose {
                        Rectangular()
                    }
                }
            }
        )
        let alphaGr = Binding (
            get: { alpha },
            set: { alpha = $0
                if $0 > 0.0 {
                    if trigChoose {
                        Rectangular()
                    }
                }
            }
        )
        let betaGr = Binding (
            get: { beta },
            set: { beta = $0
                if $0 > 0.0 {
                    Rectangular()
                }
            }
        )
        let gammaGr = Binding (
            get: { gamma },
            set: { gamma = $0
                if $0 > 0.0 {
                    Rectangular()
                }
            }
        )
        
        NavigationView {
            VStack {
                ScrollView(.vertical) {
                    VStack {
                        VStack {
                            InputComponent(name: "A side", inputName: "a", inputValue: aSide)
                                .focused($focusedField, equals: .aSideField)
                            InputComponent(name: "B side", inputName: "b", inputValue: bSide)
                                .focused($focusedField, equals: .bSideField)
                            InputComponent(name: "C side", inputName: "c", inputValue: cSide)
                                .focused($focusedField, equals: .cSideField)
                            InputComponent(name: "Angle α", inputName: "α", inputValue: alphaGr)
                                .focused($focusedField, equals: .alphaField)
                            InputComponent(name: "Angle β", inputName: "β", inputValue: betaGr)
                                .focused($focusedField, equals: .betaField)
                            InputComponent(name: "Angle γ", inputName: "γ", inputValue: gammaGr)
                                .focused($focusedField, equals: .gammaField)
                        }
                        .padding(.leading)
                        Button("Show triangle") {
                            
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                BannerView()
                    .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Button("AC") {
                            a = 0.0
                            b = 0.0
                            c = 0.0
                            alpha = 0.0
                            beta = 0.0
                            gamma = 0.0
                        }
                    }
                    Spacer()
                    HStack {
                        Button("Done") {
                            focusedField = nil
                        }
                        Button {
                            switch focusedField {
                            case .aSideField:
                                focusedField = nil
                            case .bSideField:
                                focusedField = .aSideField
                            case .cSideField:
                                focusedField = .bSideField
                            case .alphaField:
                                focusedField = .cSideField
                            case .betaField:
                                focusedField = .alphaField
                            case .gammaField:
                                focusedField = .betaField
                            default:
                                focusedField = nil
                            }
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        Button {
                            switch focusedField {
                            case .aSideField:
                                focusedField = .bSideField
                            case .bSideField:
                                focusedField = .cSideField
                            case .cSideField:
                                focusedField = .alphaField
                            case .alphaField:
                                focusedField = .betaField
                            case .betaField:
                                focusedField = .gammaField
                            default:
                                focusedField = nil
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                    }
                }
            }
            .padding(.top, 10.0)
        }
        .toolbar {
            ToolbarItem {
                HStack {
                    switch trigChoose {
                    case true:
                        Button("Rectangular") {
                            trigChoose = false
                        }
                    default:
                        Button("Equilateral") {
                            trigChoose = true
                        }
                    }
                }
            }
        }
        .navigationTitle("Triangle solver")
        .navigationBarTitleDisplayMode(.large)
        .onTapToDismissKeyboard()
    }
}
// MARK: - SIMULATOR PREVIEW
struct TriangleView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleView()
    }
}
