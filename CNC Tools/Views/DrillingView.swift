import SwiftUI
import CoreData
import StoreKit
import ConfettiSwiftUI

struct DrillingView: View {
    /// # - AppStorage
    @AppStorage("units") var units: Bool = false // MM - false ; Inch - true
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("feedback_style") var sensoryFeedbackStyle: String = "Light"
    
    /// # - Enums
    enum Field: Hashable {
        case toolDiamField
        case cutSpeedField
        case spinSpeedField
        case feedPerRevField
        case feedRateField
    }
    
    /// # - Environments
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var purchaseManager: IAPManager
    
    /// # - States
    @StateObject var viewModel = ViewModel()
    @FocusState private var focusedField: Field?
    
    @State var toolDiam: Double = 0.0
    @State var cuttingSpeed: Double = 0.0
    @State var spindelSpeed: Double = 0.0
    @State var feedPerRev: Double = 0.0
    @State var feedRate: Double = 0.0
    @State var counter: Int = 0
    
    @State var openSettingsView: Bool = false
    
    /// # -  Functions
    private func hapticFeedbacker() {
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
    func saveTool() {
        let newTool = Tool(context: viewContext)
        newTool.toolDiameterDrill = toolDiam
        newTool.spindelSpeedDrill = spindelSpeed
        newTool.feedRateDrill = feedRate
        newTool.toolNameDrills = viewModel.toolName
        newTool.toolType = "drilling"
        if units {
            viewModel.unit = "mm/min"
        } else {
            viewModel.unit = "in/min"
        }
        newTool.mmInchChoosed = viewModel.unit
        do {
            try viewContext.save()
            clearSections()
            print("Tool saved successfully")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func cuttingSpeedFunc() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if units {
                cuttingSpeed = (Double.pi * toolDiam * spindelSpeed) / 1000.0   // MM
            } else {
                cuttingSpeed = (Double.pi * toolDiam * spindelSpeed) / 12.0    // INCH
            }
        }
    }
    func spindelSpeedFunc() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if units {
                spindelSpeed = (cuttingSpeed * 1000.0) / (Double.pi * toolDiam)
            } else {
                spindelSpeed = (cuttingSpeed * 12.0) / (Double.pi * toolDiam)
            }
        }
    }
    func feedPerRevFunc() {
        withAnimation(.easeInOut(duration: 0.3)) {
            feedPerRev = feedRate / spindelSpeed
        }
    }
    func feedRateFunc() {
        withAnimation(.easeInOut(duration: 0.3)) {
            feedRate = feedPerRev * spindelSpeed
        }
    }
    func clearSections() {
        withAnimation(.easeInOut(duration: 0.3)) {
            toolDiam = 0.0
            cuttingSpeed = 0.0
            spindelSpeed = 0.0
            feedPerRev = 0.0
            feedRate = 0.0
        }
    }
    
    var body: some View {
        let tDiam = Binding(
            get: { toolDiam },
            set: { toolDiam = $0
                if $0 > 0.0 {
                    cuttingSpeedFunc()
                    spindelSpeedFunc()
                }
            }
        )
        let cSpeed = Binding(
            get: { cuttingSpeed },
            set: { cuttingSpeed = $0
                if $0 > 0.0 {
                    spindelSpeedFunc()
                }
            }
        )
        let sSpeed = Binding(
            get: { spindelSpeed },
            set: { spindelSpeed = $0
                if $0 > 0.0 {
                    cuttingSpeedFunc()
                    feedRateFunc()
                }
            }
        )
        let fPerRev = Binding(
            get: { feedPerRev },
            set: { feedPerRev = $0
                if $0 > 0.0 {
                    feedRateFunc()
                }
            }
        )
        let fRate = Binding(
            get: { feedRate },
            set: { feedRate = $0
                if $0 > 0.0 {
                    feedPerRevFunc()
                }
            }
        )
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea(.all)
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        PremiumBanner()
                        VStack {
                            InputComponent(name: "Tool diameter", inputName: "diam", inputValue: tDiam)
                                .focused($focusedField, equals: .toolDiamField)
                            InputComponent(name: "Cutting speed", inputName: "vc", inputValue: cSpeed)
                                .focused($focusedField, equals: .cutSpeedField)
                            InputComponent(name: "Spindel speed", inputName: "n", inputValue: sSpeed)
                                .focused($focusedField, equals: .spinSpeedField)
                            Divider()
                            InputComponent(name: "Feed per revolution", inputName: "fr", inputValue: fPerRev)
                                .focused($focusedField, equals: .feedPerRevField)
                            InputComponent(name: "Feed rate", inputName: "vf", inputValue: fRate)
                                .focused($focusedField, equals: .feedRateField)
                            Spacer()
                                .frame(height: 50)
                        }
                        .padding(.all)
                    }
                    .scrollDismissesKeyboard(.immediately)
                }
                .confettiCannon(counter: $counter, num: 100, colors: [.blue, .red, .green, .yellow, .pink, .purple, .orange], confettiSize: 15, rainHeight: 900.0, radius: 600.0)
                if viewModel.showAlert {
                    CustomAlert(title: "Enter tool name.",
                                subTitle: "Please enter a name for the tool.",
                                inputName: "Tool name",
                                input: $viewModel.toolName,
                                firstButtonName: "Cancel",
                                firstButtonAction: { hapticFeedbacker()
                        viewModel.showAlert = false },
                                secondButtonName: "Save",
                                secondButtonAction: { hapticFeedbacker()
                        saveTool()
                        viewModel.toolName = ""
                        viewModel.showAlert = false
                        counter += 1})
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
                            hapticFeedbacker()
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
            .toolbar {
                HStack(alignment: .center) {
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
                    /// # - Save
                    if purchaseManager.hasUnlockedPremium {
                        if spindelSpeed > 0.0 && feedRate > 0.0 {
                            ToolbarButtonComp(name: "Save", color: .indigo, action: { viewModel.showAlert = true })
                        }
                    }
                }
            }
        }
        .onTapToDismissKeyboard()
    }
}

