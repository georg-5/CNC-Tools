import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tool.mmOrInch, ascending: true)],
        animation: .default)
        private var metricInches: FetchedResults<Tool>
    
    @State private var metricInchesCheck = true    // true - MM, false - INCH
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    NavigationLink(destination: MillingView()) {
                        Text("MILLING")
                    }
                    NavigationLink(destination: TurningView()) {
                        Text("TURNING")
                    }
                    NavigationLink(destination: DrillingView()) {
                        Text("DRILLING")
                    }
                }
                .font(.custom("SFPro-ExpandedHeavy", size: 50))
                HStack(spacing: 25.0) {
                    NavigationLink(destination: SavedToolsView()) {
                        Image(systemName: "rectangle.stack")
                    }
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
                .padding(.top)
                .font(.system(size: 30))
                Spacer()
                Text("CNC TOOLS")
                    .font(.custom("SFPro-ExpandedUltraLight", size: 15))
            }
            .foregroundColor(.white)
            .onAppear {
                if let metricInchesCored = metricInches.first {
                    metricInchesCheck = metricInchesCored.mmOrInch
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
