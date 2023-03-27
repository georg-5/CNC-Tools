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
                        InputComponent(name: "Tool diameter", inputName: "diam", inputValue: tDiam)
                            .focused($focusedField, equals: .toolDiamField)
                        InputComponent(name: "Cutting speed", inputName: "vc", inputValue: cSpeed)
                            .focused($focusedField, equals: .cutSpeedField)
                        InputComponent(name: "Spindel speed", inputName: "n", inputValue: sSpeed)
                            .focused($focusedField, equals: .spinSpeedField)
                        InputComponent(name: "Number of teeth", inputName: "z", inputValue: nOfZ)
                            .focused($focusedField, equals: .numOfZField)
                            .padding(.top, 19.0)
                        InputComponent(name: "Feed per tooth ", inputName: "fz", inputValue: fPerTooth)
                            .focused($focusedField, equals: .feedPerToothField)
                        InputComponent(name: "Feed rate", inputName: "vf", inputValue: fRate)
                            .focused($focusedField, equals: .feedRateField)
                    }
                    .padding(.leading)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    HStack {
                        Button {
                            switch focusedField {
                            case .toolDiamField:
                                focusedField = nil
                            case .cutSpeedField:
                                focusedField = .toolDiamField
                            case .spinSpeedField:
                                focusedField = .cutSpeedField
                            case .numOfZField:
                                focusedField = .spinSpeedField
                            case .feedPerToothField:
                                focusedField = .numOfZField
                            case .feedRateField:
                                focusedField = .feedPerToothField
                            default:
                                focusedField = nil
                            }
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        Button {
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
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                        Button("Done") {
                            switch focusedField {
                            case .toolDiamField:
                                focusedField = nil
                            case .cutSpeedField:
                                focusedField = nil
                            case .spinSpeedField:
                                focusedField = nil
                            case .numOfZField:
                                focusedField = nil
                            case .feedPerToothField:
                                focusedField = nil
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
        .onTapToDismissKeyboard()
    }
}

struct MillingView_Previews: PreviewProvider {
    static var previews: some View {
        MillingView()
    }
}
