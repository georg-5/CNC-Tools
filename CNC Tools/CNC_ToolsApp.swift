import SwiftUI

@main
struct CNC_ToolsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .colorScheme(.dark)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
