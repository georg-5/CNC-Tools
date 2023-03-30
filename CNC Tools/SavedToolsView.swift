import SwiftUI
import CoreData

struct SavedToolsView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFPro-ExpandedMedium", size: 34)!]
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        }
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Tool.entity(), sortDescriptors: [])
    private var tools: FetchedResults<Tool>
    
    // FUNC
    private func deleteItems(offsets: IndexSet) {
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
                    if $tools.category == 1.0 {
                        Section(header: Text("Mills")) {
                            ForEach(tools) { tool in
                                SavedComponent(toolName: tool.toolName ?? "",
                                               toolDiameter: tool.toolDiameter,
                                               spindelSpeed: tool.spindelSpeed,
                                               feedRate: tool.feedRate)
                            }
                            .onDelete(perform: deleteItems)
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
    }
}

struct SavedToolsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedToolsView()
    }
}
