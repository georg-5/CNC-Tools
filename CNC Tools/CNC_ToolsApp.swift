import SwiftUI
import StoreKit
import Firebase

@main
struct CNC_ToolsApp: App {
    /// # - AppStorage
    @AppStorage("units") var units: Bool = false // MM - false ; Inch - true
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("launches") var launches = 0
    
    /// # - States
    @StateObject private var purchaseManager = IAPManager()
    
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(purchaseManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
