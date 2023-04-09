import SwiftUI

struct ToolCheckComp: View {
    @Binding var showAlertForSavedTool: Bool
    let checkValuesInCoreData: () -> Bool

    var body: some View {
        Group {
            if checkValuesInCoreData() {
                NavigationLink(destination: SavedToolsView()) {
                    Text("TOOLS")
                }
            } else {
                Button(action: {
                    showAlertForSavedTool = true
                }, label: {
                    Text("TOOLS")
                })
                .alert(isPresented: $showAlertForSavedTool) {
                    Alert(
                        title: Text("No saved tools yet!")
                    )
                }
            }
        }
    }
}

