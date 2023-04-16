import SwiftUI
import CoreData
import StoreKit

// MARK: - DRILLING VIEW
struct DrillingView: View {
    // MARK: - INIT
    
    // MARK: - ENUMS
    enum Field: Hashable {
        case toolDiamField
        case cutSpeedField
        case spinSpeedField
        case feedPerRevField
        case feedRateField
    }
    
    // MARK: -  VARIABLES
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(entity: Tool.entity(), sortDescriptors: []) private var metricInches: FetchedResults<Tool>
    @StateObject private var storeKitManager = StoreKitManager()
    @State private var toolDiam = 0.0
    @State private var cuttingSpeed = 0.0
    @State private var spindelSpeed = 0.0
    @State private var feedPerRev = 0.0
    @State private var feedRate = 0.0
    @FocusState private var focusedField: Field?
    @State private var showAlert = false
    @State private var toolName = ""
    @State private var metricInchesCheck = true    // true - MM, false - INCH
    
    // MARK: - FUNCTIONS
    func saveTool() {
        let newTool = Tool(context: viewContext)
            newTool.toolDiameterDrill = toolDiam
            newTool.spindelSpeedDrill = spindelSpeed
            newTool.feedRateDrill = feedRate
            newTool.toolNameDrills = toolName
            newTool.toolType = "drilling"
            do {
                try viewContext.save()
                print("Tool saved successfully")
            } catch {
                let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
    func cuttingSpeedFunc() {
        if metricInchesCheck {
            cuttingSpeed = (Double.pi * toolDiam * spindelSpeed) / 1000.0   // MM
        } else {
            cuttingSpeed = (Double.pi * toolDiam * spindelSpeed) / 12.0    // INCH
        }
    }
    func spindelSpeedFunc() {
        if metricInchesCheck {
            spindelSpeed = (cuttingSpeed * 1000.0) / (Double.pi * toolDiam)
        } else {
            spindelSpeed = (cuttingSpeed * 12.0) / (Double.pi * toolDiam)
        }
    }
    func feedPerRevFunc() {
        feedPerRev = feedRate / spindelSpeed
    }
    func feedRateFunc() {
        feedRate = feedPerRev * spindelSpeed
    }
    
    var body: some View {
        // MARK: - BINDINGS
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
            let fPerRev = Binding (
                get: { feedPerRev },
                set: { feedPerRev = $0
                    if $0 > 0.0 {
                        feedRateFunc()
                    }
                }
            )
            let fRate = Binding (
                get: { feedRate },
                set: { feedRate = $0
                    if $0 > 0.0 {
                        feedPerRevFunc()
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
                        InputComponent(name: "Feed per revolution", inputName: "fr", inputValue: fPerRev)
                            .focused($focusedField, equals: .feedPerRevField)
                            .padding(.top, 19.0)
                        InputComponent(name: "Feed rate", inputName: "vf", inputValue: fRate)
                            .focused($focusedField, equals: .feedRateField)
                    }
                    .padding(.leading)
                }
                .scrollDismissesKeyboard(.immediately)
                if storeKitManager.premiumUnlocked == false {
                    BannerView()
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    HStack {
                        Button("Done") {
                            focusedField = nil
                        }
                        Button {
                            switch focusedField {
                            case .toolDiamField:
                                focusedField = nil
                            case .cutSpeedField:
                                focusedField = .toolDiamField
                            case .spinSpeedField:
                                focusedField = .cutSpeedField
                            case .feedPerRevField:
                                focusedField = .spinSpeedField
                            case .feedRateField:
                                focusedField = .feedPerRevField
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
                                focusedField = .feedPerRevField
                            case .feedPerRevField:
                                focusedField = .feedRateField
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
                if storeKitManager.premiumUnlocked {
                    if spindelSpeed > 0.0 && feedRate > 0.0 {
                        HStack {
                            Button("Save") {
                                showAlert = true
                            }
                            .font(Font.custom("TestSohne-Buch", size: 17))
                            .alert("Enter tool name.", isPresented: $showAlert, actions: {
                                TextField("Tool name", text: $toolName)
                                    .foregroundColor(.black)
                                Button("Save", action: {
                                    saveTool()
                                    toolName = ""
                                })
                                Button("Cancel", role: .cancel, action: {})
                            }, message: {
                                Text("Please enter a name for the tool.")
                            })
                        }
                    }
                }
            }
        }
        .navigationTitle("DRILLING")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "chevron.left")
                            .font(Font.system(size: 16))
                        Text("Back")
                            .font(Font.custom("TestSohne-Buch", size: 17))
                    }
                }
            }
        }
        .onAppear {
            if let metricInchesCored = metricInches.first {
                metricInchesCheck = metricInchesCored.mmOrInch
            }
            SKPaymentQueue.default().add(storeKitManager)
        }
        .onTapToDismissKeyboard()
        
    }
}

// MARK: - SIMULATOR PREVIEW
struct DrillingView_Previews: PreviewProvider {
    static var previews: some View {
        DrillingView()
    }
}
