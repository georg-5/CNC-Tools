import SwiftUI
import CoreData

// MARK: - MILLING VIEW
struct MillingView: View {
    
    // MARK: - ENUMS
    enum Field: Hashable {
        case toolDiamField
        case cutSpeedField
        case spinSpeedField
        case numOfZField
        case feedPerToothField
        case feedRateField
    }
    
    // MARK: - VARIABLES
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(entity: Tool.entity(), sortDescriptors: []) private var metricInches: FetchedResults<Tool>
    @State private var toolDiam = 0.0
    @State private var cuttingSpeed = 0.0
    @State private var spindelSpeed = 0.0
    @State private var numOfZ = 0.0
    @State private var feedPerTooth = 0.0
    @State private var feedRate = 0.0
    @FocusState private var focusedField: Field?
    @State private var showAlert = false
    @State private var toolName = ""
    @State private var metricInchesCheck = true    // true - MM, false - INCH
    
    // MARK: - FUNCTIONS
    func saveTool() {
        let newTool = Tool(context: viewContext)
            newTool.toolDiameterMill = toolDiam
            newTool.spindelSpeed = spindelSpeed
            newTool.feedRate = feedRate
            newTool.toolNameMills = toolName
            newTool.toolType = "milling"
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
    func feedPerToothFunc() {
        feedPerTooth = feedRate / (spindelSpeed * numOfZ)
    }
    func feedRateFunc() {
        feedRate = feedPerTooth * spindelSpeed * numOfZ
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
                        InputComponent(name: "TOOL DIAMETER", inputName: "diam", inputValue: tDiam)
                            .focused($focusedField, equals: .toolDiamField)
                        InputComponent(name: "CUTTING SPEED", inputName: "vc", inputValue: cSpeed)
                            .focused($focusedField, equals: .cutSpeedField)
                        InputComponent(name: "SPINDEL SPEED", inputName: "n", inputValue: sSpeed)
                            .focused($focusedField, equals: .spinSpeedField)
                        InputComponent(name: "NUMBER OF TEETH", inputName: "z", inputValue: nOfZ)
                            .focused($focusedField, equals: .numOfZField)
                            .padding(.top, 19.0)
                        InputComponent(name: "FEED PER TOOTH", inputName: "fz", inputValue: fPerTooth)
                            .focused($focusedField, equals: .feedPerToothField)
                        InputComponent(name: "FEED RATE", inputName: "vf", inputValue: fRate)
                            .focused($focusedField, equals: .feedRateField)
                    }
                    .padding(.leading)
                }
                .scrollDismissesKeyboard(.immediately)
                BannerView()
                    .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
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
                    }
                }
            }
            .padding(.top, 10.0)
        }
        .toolbar {
            ToolbarItem {
                if spindelSpeed > 0.0 && feedRate > 0.0 {
                    HStack {
                        Button("Save") {
                            showAlert = true
                        }
                        .font(Font.custom("SpaceMono-Regular", size: 17))
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
        .navigationTitle("MILLING")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(Font.system(size: 16))
                        Text("Back")
                            .font(Font.custom("SpaceMono-Regular", size: 17))
                    }
                }
            }
        }
        .onAppear {
            if let metricInchesCored = metricInches.first {
                metricInchesCheck = metricInchesCored.mmOrInch
            }
        }
        .onTapToDismissKeyboard()
        
    }
}

// MARK: - SIMULATOR PREVIEW
struct MillingView_Previews: PreviewProvider {
    static var previews: some View {
        MillingView()
    }
}
