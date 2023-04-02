import SwiftUI
import CoreData

struct SettingsView: View {
    // MARK: - VARIABLES
    @State private var chooseMmOrInch: Bool = true  // true - MM, false - INCH
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Tool.entity(), sortDescriptors: []) private var tools: FetchedResults<Tool>
    
    // MARK: - INIT
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFPro-ExpandedMedium", size: 34)!]
    }

    // MARK: - FUNCTIONS
    func updateMetricInches() {
        let metricInches: Tool = tools.first ?? Tool(context: viewContext)
        metricInches.mmOrInch = chooseMmOrInch
        do {
            try viewContext.save()
            print("Tool are \(metricInches.mmOrInch)")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Button("MM") {
                        chooseMmOrInch = true
                        updateMetricInches()
                    }
                    .opacity(chooseMmOrInch ? 1.0 : 0.3)
                    Text("/")
                    Button("INCH") {
                        chooseMmOrInch = false
                        updateMetricInches()
                    }
                    .opacity(chooseMmOrInch ? 0.3 : 1.0)
                }
                .font(.custom("SFPro-ExpandedBold", size: 50))
                .foregroundColor(.white)
                Spacer()
                BannerView()
                    .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if let tool = tools.first {
                chooseMmOrInch = tool.mmOrInch
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
