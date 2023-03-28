import SwiftUI
import CoreData

struct SettingsView: View {
    @State private var chooseMmOrInch: Bool = true  // true - MM, false - INCH
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Tool.entity(), sortDescriptors: []) private var tools: FetchedResults<Tool>

    init() {
           UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFPro-ExpandedMedium", size: 34)!]
       }
    
    func chooseMmOrInchFunc() {
        let metricInches: Tool
        if let tool = tools.first {
            metricInches = tool
        } else {
            metricInches = Tool(context: viewContext)
        }
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
                        chooseMmOrInchFunc()
                    }
                    .opacity(chooseMmOrInch ? 1.0 : 0.3)
                    Text("/")
                    Button("INCH") {
                        chooseMmOrInch = false
                        chooseMmOrInchFunc()
                    }
                    .opacity(chooseMmOrInch ? 0.3 : 1.0)
                }
                .font(.custom("SFPro-ExpandedBold", size: 50))
                .foregroundColor(.white)
                Spacer()
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
