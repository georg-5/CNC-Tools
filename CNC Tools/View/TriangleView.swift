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
    
    // MARK: - FUNCS
    func findCSide() {
        if b == 0.0 || a == 0.0 {
            c = 0.0
        } else {
            c = (a * a) + (b * b)
            c = sqrt(c)
        }
    }
    func findASide() {
        if b == 0.0 || c == 0.0 {
            a = 0.0
        } else {
            a = (b * b) - (c * c)
            a = sqrt(a)
        }
    }
    func findBSide() {
        if a == 0.0 || c == 0.0 {
            b = 0.0
        } else {
            b = (a * a) - (c * c)
            b = sqrt(b)
        }
    }

    var body: some View {
        let aSide = Binding (
            get: { a },
            set: { a = $0
                if $0 > 0.0 {
                    if trigChoose {
                        findCSide()
                    }
                }
            }
        )
        let bSide = Binding (
            get: { b },
            set: { b = $0
                if $0 > 0.0 {
                    if trigChoose {
                        findCSide()
                    }
                }
            }
        )
        let cSide = Binding (
            get: { c },
            set: { c = $0
                if $0 > 0.0 {
                    if trigChoose {
                   
                    }
                }
            }
        )
        let alphaGr = Binding (
            get: { alpha },
            set: { alpha = $0
                if $0 > 0.0 {
                    if trigChoose {
                        alpha = atan(a / b)
                        print(alpha)
                    }
                }
            }
        )
        let betaGr = Binding (
            get: { beta },
            set: { beta = $0
                if $0 > 0.0 {

                }
            }
        )
        let gammaGr = Binding (
            get: { gamma },
            set: { gamma = $0
                if $0 > 0.0 {

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
