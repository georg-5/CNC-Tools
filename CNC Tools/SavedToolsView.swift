import SwiftUI
import CoreData

struct SavedToolsView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFPro-ExpandedMedium", size: 34)!]
        }
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Tool.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "toolType == %@", "milling")
    ) private var toolsMills: FetchedResults<Tool>

    @FetchRequest(
        entity: Tool.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "toolType == %@", "turning")
    ) private var toolsTurns: FetchedResults<Tool>

    @FetchRequest(
        entity: Tool.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "toolType == %@", "drilling")
    ) private var toolsDrills: FetchedResults<Tool>

    
    @State var toolsNamesMills = [String]()
    @State var toolsNamesTurns = [String]()
    @State var toolsNamesDrills = [String]()
    @State private var metricInchesCheck = true
    
    // FUNC
    private func deleteItemsMills(offsets: IndexSet) {
            withAnimation {
                offsets.map { toolsMills[$0] }.forEach(viewContext.delete)

                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    private func deleteItemsTurns(offsets: IndexSet) {
            withAnimation {
                offsets.map { toolsTurns[$0] }.forEach(viewContext.delete)

                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    private func deleteItemsDrills(offsets: IndexSet) {
            withAnimation {
                offsets.map { toolsDrills[$0] }.forEach(viewContext.delete)

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
                    if !toolsNamesMills.isEmpty {
                        Section(header: Text("Milling")) {
                            ForEach(toolsMills) { tool in
                                SavedComponent(toolName: tool.toolNameMills ?? "",
                                               toolDiameter: tool.toolDiameterMill,
                                               spindelSpeed: tool.spindelSpeed,
                                               feedRate: tool.feedRate)
                            }
                            .onDelete(perform: deleteItemsMills)
                        }
                        .font(.custom("SFPro-ExpandedRegular", size: 13))
                    }
                    if !toolsNamesTurns.isEmpty {
                        Section(header: Text("Turning")) {
                            ForEach(toolsTurns) { tool in
                                SavedComponent(toolName: tool.toolNameTurns ?? "",
                                               toolDiameter: tool.outerDiameter,
                                               spindelSpeed: tool.spindelSpeedTurn,
                                               feedRate: tool.feedRateTurn)
                            }
                            .onDelete(perform: deleteItemsTurns)
                        }
                        .font(.custom("SFPro-ExpandedRegular", size: 13))
                    }
                    if !toolsNamesDrills.isEmpty {
                        Section(header: Text("Drilling")) {
                            ForEach(toolsDrills) { tool in
                                SavedComponent(toolName: tool.toolNameDrills ?? "",
                                               toolDiameter: tool.toolDiameterDrill,
                                               spindelSpeed: tool.spindelSpeedDrill,
                                               feedRate: tool.feedRateDrill)
                            }
                            .onDelete(perform: deleteItemsDrills)
                        }
                        .font(.custom("SFPro-ExpandedRegular", size: 13))
                    }
                }
            }
        }
        .navigationTitle("Saved tools")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onAppear {
            if let metricInchesCored = toolsMills.first {
                metricInchesCheck = metricInchesCored.mmOrInch
            }
            toolsNamesMills = toolsMills.compactMap { $0.toolNameMills }
            toolsNamesTurns = toolsTurns.compactMap { $0.toolNameTurns }
            toolsNamesDrills = toolsDrills.compactMap { $0.toolNameDrills }
        }
    }
}

struct SavedToolsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedToolsView()
    }
}
