import SwiftUI
import CoreData

struct SavedToolsView: View {
    // MARK: - INIT
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFPro-ExpandedMedium", size: 34)!]
    }
    
    // MARK: - VARIABLES
    @Environment(\.managedObjectContext) private var viewContext
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
                                SavedComponent(toolName: tool.toolNameMills ?? "", toolDiameter: tool.toolDiameterMill, spindelSpeed: tool.spindelSpeed, feedRate: tool.feedRate)
                            }
                            .onDelete(perform: { offsets in
                                deleteItems(offsets: offsets, tools: toolsMills)
                            })
                        }
                        .font(.custom("SFPro-ExpandedRegular", size: 13))
                    }
                    if !toolsTurns.isEmpty {
                        Section(header: Text("Turning")) {
                            ForEach(toolsTurns) { tool in
                                SavedComponent(toolName: tool.toolNameTurns ?? "", toolDiameter: tool.outerDiameter, spindelSpeed: tool.spindelSpeedTurn, feedRate: tool.feedRateTurn)
                            }
                            .onDelete(perform: { offsets in
                                deleteItems(offsets: offsets, tools: toolsTurns)
                            })
                        }
                        .font(.custom("SFPro-ExpandedRegular", size: 13))
                    }
                    if !toolsDrills.isEmpty {
                        Section(header: Text("Drilling")) {
                            ForEach(toolsDrills) { tool in
                                SavedComponent(toolName: tool.toolNameDrills ?? "", toolDiameter: tool.toolDiameterDrill, spindelSpeed: tool.spindelSpeedDrill, feedRate: tool.feedRateDrill)
                            }
                            .onDelete(perform: { offsets in
                                deleteItems(offsets: offsets, tools: toolsDrills)
                            })
                        }
                        .font(.custom("SFPro-ExpandedRegular", size: 13))
                    }
                }
                BannerView()
                    .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
            }
        }
        .navigationTitle("Saved tools")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if let metricInchesCored = toolsMills.first {
                metricInchesCheck = metricInchesCored.mmOrInch
            }
        }
    }
}

struct SavedToolsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedToolsView()
    }
}
