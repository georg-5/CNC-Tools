//
//  CNC_ToolsApp.swift
//  CNC Tools
//
//  Created by Georgi Vorobjov on 19.03.2023.
//

import SwiftUI

@main
struct CNC_ToolsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
