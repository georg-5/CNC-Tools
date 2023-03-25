import SwiftUI

struct MillingView: View {
    init() {
            UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFPro-ExpandedMedium", size: 34)!]
        }
    
    enum Field: Hashable {
        case toolDiamField
        case cutSpeedField
        case spinSpeedField
        case numOfZField
        case feedPerToothField
        case feedRateField
    }
    
    // - VARIABLES
    @State var toolDiam = 0.0
    @State var cuttingSpeed = 0.0
    @State var spindelSpeed = 0.0
    @State var numOfZ = 0.0
    @State var feedPerTooth = 0.0
    @State var feedRate = 0.0
    @FocusState var focusedField: Field?
    
    // - FUNCS
    func cuttingSpeedFunc() {
        cuttingSpeed = (Double.pi * toolDiam * spindelSpeed) / 1000.0
    }
    func spindelSpeedFunc() {
        spindelSpeed = (cuttingSpeed * 1000.0) / (Double.pi * toolDiam)
    }
    func feedPerToothFunc() {
        feedPerTooth = feedRate / (spindelSpeed * numOfZ)
    }
    func feedRateFunc() {
        feedRate = feedPerTooth * spindelSpeed * numOfZ
    }
    
    // - FORMATTERS
        // - 2 DIGITS AFTER ZERO
    private let twoDigits: NumberFormatter = {
         let formatter = NumberFormatter()
         formatter.locale = Locale.current
         formatter.numberStyle = .decimal
         formatter.minimumFractionDigits = 2
         formatter.maximumFractionDigits = 2
         formatter.zeroSymbol = ""
         return formatter
     }()
        // - 1 DIGIT AFTER ZERO
    private let oneDigit: NumberFormatter = {
         let formatter = NumberFormatter()
         formatter.locale = Locale.current
         formatter.numberStyle = .decimal
         formatter.minimumFractionDigits = 1
         formatter.maximumFractionDigits = 1
         formatter.zeroSymbol = ""
         return formatter
     }()
        // - 0 DIGIT AFTER ZERO
    private let zeroDigits: NumberFormatter = {
         let formatter = NumberFormatter()
         formatter.locale = Locale.current
         formatter.numberStyle = .decimal
         formatter.minimumFractionDigits = 0
         formatter.maximumFractionDigits = 0
         formatter.zeroSymbol = ""
         return formatter
     }()
    
    var body: some View {
        
        // BINDINGS
            let tDiam = Binding (
                get: { toolDiam },
                set: { toolDiam = $0
                    if $0 > 0.0 {
                        cuttingSpeedFunc()
                        spindelSpeedFunc()
                    }
                }
            )
            let cSpeed = Binding (
                get: { cuttingSpeed },
                set: { cuttingSpeed = $0
                    if $0 > 0.0 {
                        spindelSpeedFunc()
                    }
                }
            )
            let sSpeed = Binding (
                get: { spindelSpeed },
                set: { spindelSpeed = $0
                    if $0 > 0.0 {
                        cuttingSpeedFunc()
                        feedRateFunc()
                    }
                }
            )
            let nOfZ = Binding (
                get: { numOfZ },
                set: { numOfZ = $0
                    if $0 > 0.0 {
                        feedRateFunc()
                        feedPerToothFunc()
                    }
                }
            )
            let fPerTooth = Binding (
                get: { feedPerTooth },
                set: { feedPerTooth = $0
                    if $0 > 0.0 {
                        feedRateFunc()
                    }
                }
            )
            let fRate = Binding (
                get: { feedRate },
                set: { feedRate = $0
                    if $0 > 0.0 {
                        feedPerToothFunc()
                    }
                }
            )
        NavigationView {
            VStack {
                ScrollView (.vertical) {
                    VStack() {
                        InputComponent(name: "Tool diameter", inputName: "diam", inputValue: tDiam, inputFormatter: oneDigit)
                            .focused($focusedField, equals: .toolDiamField)
                        InputComponent(name: "Cutting speed", inputName: "vc", inputValue: cSpeed, inputFormatter: zeroDigits)
                            .focused($focusedField, equals: .cutSpeedField)
                        InputComponent(name: "Spindel speed", inputName: "n", inputValue: sSpeed, inputFormatter: zeroDigits)
                            .focused($focusedField, equals: .spinSpeedField)
                        InputComponent(name: "Number of teeth", inputName: "z", inputValue: nOfZ, inputFormatter: zeroDigits)
                            .focused($focusedField, equals: .numOfZField)
                            .padding(.top, 19.0)
                        InputComponent(name: "Feed per tooth ", inputName: "fz", inputValue: fPerTooth, inputFormatter: twoDigits)
                            .focused($focusedField, equals: .feedPerToothField)
                        InputComponent(name: "Feed rate", inputName: "vf", inputValue: fRate, inputFormatter: zeroDigits)
                            .focused($focusedField, equals: .feedRateField)
                    }
                    .padding(.leading)
                    Spacer()
                    Text("CNC TOOLS")
                        .font(.custom("SFPro-ExpandedUltraLight", size: 15))
                        .padding(.leading, 14.0)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Button("Done") {
                            switch focusedField {
                            case .toolDiamField:
                                focusedField = .cutSpeedField
                            case .cutSpeedField:
                                focusedField = .spinSpeedField
                            case .spinSpeedField:
                                focusedField = .numOfZField
                            case .numOfZField:
                                focusedField = .feedPerToothField
                            case .feedPerToothField:
                                focusedField = .feedRateField
                            default:
                                focusedField = nil
                            }
                        }
                    }
                    Spacer()
                    HStack {
                        Button("Done") {
                            switch focusedField {
                            case .toolDiamField:
                                focusedField = .cutSpeedField
                            case .cutSpeedField:
                                focusedField = .spinSpeedField
                            case .spinSpeedField:
                                focusedField = .numOfZField
                            case .numOfZField:
                                focusedField = .feedPerToothField
                            case .feedPerToothField:
                                focusedField = .feedRateField
                            default:
                                focusedField = nil
                            }
                        }
                    }
                }
            }
            .padding(.top, 10.0)
        }
        .navigationTitle("Milling")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct MillingView_Previews: PreviewProvider {
    static var previews: some View {
        MillingView()
    }
}
