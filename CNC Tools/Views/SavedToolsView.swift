import SwiftUI
import CoreData
import StoreKit
import GoogleMobileAds

struct SavedToolsView: View {
    // MARK: - VARIABLES\
    @StateObject private var storeKitManager = StoreKitManager()
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode:
    Binding<PresentationMode>
    @FetchRequest(entity: Tool.entity(), sortDescriptors: [], predicate: NSPredicate(format: "toolType == %@", "milling")) private var toolsMills: FetchedResults<Tool>
    @FetchRequest(entity: Tool.entity(), sortDescriptors: [], predicate: NSPredicate(format: "toolType == %@", "turning")) private var toolsTurns: FetchedResults<Tool>
    @FetchRequest(entity: Tool.entity(), sortDescriptors: [], predicate: NSPredicate(format: "toolType == %@", "drilling")) private var toolsDrills: FetchedResults<Tool>
    @State private var metricInchesCheck = true

    // MARK: - FUNCTIONS
    private func deleteItems(offsets: IndexSet, tools: FetchedResults<Tool>) {
        withAnimation {
            offsets.map { tools[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if !toolsMills.isEmpty {
                        Section(header: Text("Milling")) {
                            ForEach(toolsMills) { tool in
                                SavedComponent(toolName: tool.toolNameMills ?? "", toolDiameter: tool.toolDiameterMill, spindelSpeed: tool.spindelSpeed, feedRate: tool.feedRate, mmInch: tool.mmInchChoosed ?? "")
                            }
                            .onDelete(perform: { offsets in
                                deleteItems(offsets: offsets, tools: toolsMills)
                            })
                        }
                    }
                    if !toolsTurns.isEmpty {
                        Section(header: Text("Turning")) {
                            ForEach(toolsTurns) { tool in
                                SavedComponent(toolName: tool.toolNameTurns ?? "", toolDiameter: tool.outerDiameter, spindelSpeed: tool.spindelSpeedTurn, feedRate: tool.feedRateTurn, mmInch: tool.mmInchChoosed ?? "")
                            }
                            .onDelete(perform: { offsets in
                                deleteItems(offsets: offsets, tools: toolsTurns)
                            })
                        }
                    }
                    if !toolsDrills.isEmpty {
                        Section(header: Text("Drilling")) {
                            ForEach(toolsDrills) { tool in
                                SavedComponent(toolName: tool.toolNameDrills ?? "", toolDiameter: tool.toolDiameterDrill, spindelSpeed: tool.spindelSpeedDrill, feedRate: tool.feedRateDrill, mmInch: tool.mmInchChoosed ?? "")
                            }
                            .onDelete(perform: { offsets in
                                deleteItems(offsets: offsets, tools: toolsDrills)
                            })
                        }
                    }
                }
                .font(.system(size: 12, weight: .bold, design: .default))
                .foregroundColor(.blue)
                .scrollContentBackground(.hidden)
                if storeKitManager.premiumUnlocked == false {
                    BannerView()
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
                }
            }
        }
        .navigationTitle("Saved Tools")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
        .onAppear {
            if let metricInchesCored = toolsMills.first {
                metricInchesCheck = metricInchesCored.mmOrInch
            }
            SKPaymentQueue.default().add(storeKitManager)
        }
        .onReceive(storeKitManager.$product) { product in
            if let _ = product {
                storeKitManager.purchaseProduct()
            }
        }
    }
}

struct SavedToolsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedToolsView()
    }
}
