import SwiftUI
import CoreData
import StoreKit

struct SavedTools: View {
    /// # - AppStorage
    @AppStorage("units") var units: Bool = false
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("feedback_style") var sensoryFeedbackStyle: String = "Light"
    
    /// # - States
    @StateObject var viewModel = ViewModel()
    
    /// # - Variables
    var badNum: Int = Int.random(in: 0...10)
    
    /// # - Environments
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    /// # - CoreData
    @FetchRequest(entity: Tool.entity(), sortDescriptors: [], predicate: NSPredicate(format: "toolType == %@", "milling")) private var toolsMills: FetchedResults<Tool>
    @FetchRequest(entity: Tool.entity(), sortDescriptors: [], predicate: NSPredicate(format: "toolType == %@", "turning")) private var toolsTurns: FetchedResults<Tool>
    @FetchRequest(entity: Tool.entity(), sortDescriptors: [], predicate: NSPredicate(format: "toolType == %@", "drilling")) private var toolsDrills: FetchedResults<Tool>
    
    /// # - Functions
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
    func deleteAll() {
        let fetchRequest = Tool.fetchRequest()
        let items = try? viewContext.fetch(fetchRequest)
        for item in items ?? [] {
            viewContext.delete(item)
        }
        try? viewContext.save()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea(.all)
                VStack {
                    if toolsMills.isEmpty && toolsTurns.isEmpty && toolsDrills.isEmpty {
                        VStack(alignment: .center) {
                            Spacer()
                            Image(systemName: "face.dashed")
                                .font(.system(size: 100))
                            Text("Hello there!")
                                .font(.custom("SFPro-Bold", size: 27))
                                .padding(.top, 5)
                            Text("\(viewModel.badNews[badNum])")
                                .multilineTextAlignment(.center)
                                .font(.custom("SFPro-Regular", size: 17))
                                .padding(.bottom)
                            Spacer()
                        }
                    } else {
                        VStack {
                            ScrollView(.vertical, showsIndicators: false) {
                                if !toolsMills.isEmpty {
                                    VStack {
                                        HStack(alignment: .bottom) {
                                            Text("Milling")
                                                .font(.custom("SFPro-Bold", size: 12))
                                                .padding(.leading)
                                                .opacity(0.5)
                                            Spacer()
                                        }
                                        VStack {
                                            ForEach(toolsMills) { tool in
                                                SavedComponent(toolName: tool.toolNameMills ?? "", toolDiameter: tool.toolDiameterMill, spindelSpeed: tool.spindelSpeed, feedRate: tool.feedRate, mmInch: tool.mmInchChoosed ?? "", tools: toolsMills)
                                            }
                                        }
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(viewModel.cornerRadius / 2)
                                    }
                                    .padding(.bottom)
                                    Divider()
                                }
                                if !toolsTurns.isEmpty {
                                    VStack {
                                        HStack {
                                            Text("Turning")
                                                .font(.custom("SFPro-Bold", size: 12))
                                                .padding(.leading)
                                                .opacity(0.5)
                                            Spacer()
                                        }
                                        VStack {
                                            ForEach(toolsTurns) { tool in
                                                SavedComponent(toolName: tool.toolNameTurns ?? "", toolDiameter: tool.outerDiameter, spindelSpeed: tool.spindelSpeedTurn, feedRate: tool.feedRateTurn, mmInch: tool.mmInchChoosed ?? "", tools: toolsTurns)
                                            }
                                        }
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(viewModel.cornerRadius / 2)
                                    }
                                    .padding(.vertical)
                                    Divider()
                                }
                                if !toolsDrills.isEmpty {
                                    VStack {
                                        HStack {
                                            Text("Drilling")
                                                .font(.custom("SFPro-Bold", size: 12))
                                                .padding(.leading)
                                                .opacity(0.5)
                                            Spacer()
                                        }
                                        VStack {
                                            ForEach(toolsDrills) { tool in
                                                SavedComponent(toolName: tool.toolNameDrills ?? "", toolDiameter: tool.toolDiameterDrill, spindelSpeed: tool.spindelSpeedDrill, feedRate: tool.feedRateDrill, mmInch: tool.mmInchChoosed ?? "", tools: toolsDrills)
                                            }
                                        }
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(viewModel.cornerRadius / 2)
                                    }
                                    .padding(.vertical)
                                    Divider()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .toolbar {
                /// # - Back button
                ToolbarButtonComp(name: "Back", color: .red, action: {dismiss()})
                /// # - Settings
                ToolbarButtonComp(name: "Settings", color: .blue, action: { hapticFeedbacker()
                                  viewModel.openSettingsView = true })
                .sheet(isPresented: $viewModel.openSettingsView) {
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
                /// # - Clear data
                if !toolsMills.isEmpty || !toolsTurns.isEmpty || !toolsDrills.isEmpty {
                    ToolbarButtonComp(name: "Clear", color: .indigo, action: { deleteAll()
                        hapticFeedbacker() })
                }
            }
        }
    }
}
