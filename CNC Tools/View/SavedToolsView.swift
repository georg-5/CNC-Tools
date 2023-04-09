import SwiftUI
import CoreData

struct SavedToolsView: View {
    // MARK: - VARIABLES
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
                                SavedComponent(toolName: tool.toolNameMills ?? "", toolDiameter: tool.toolDiameterMill, spindelSpeed: tool.spindelSpeed, feedRate: tool.feedRate)
                            }
                            .onDelete(perform: { offsets in
                                deleteItems(offsets: offsets, tools: toolsMills)
                            })
                        }
                        .font(.custom("SpaceMono-Regular", size: 12))
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
                        .font(.custom("SpaceMono-Regular", size: 12))
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
                        .font(.custom("SpaceMono-Regular", size: 12))
                    }
                }
                .listRowBackground(Color.clear)
                BannerView()
                    .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
            }
        }
        .navigationTitle("SAVED TOOLS")
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
