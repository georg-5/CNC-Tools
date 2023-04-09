import SwiftUI
import CoreData

struct SettingsView: View {
    // MARK: - VARIABLES
    @State private var chooseMmOrInch: Bool = true  // true - MM, false - INCH
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(entity: Tool.entity(), sortDescriptors: []) private var tools: FetchedResults<Tool>

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
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "plusminus")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        Text("UNITS OF MEASUREMENTS")
                        Spacer()
                    }
                    .padding(.leading)
                    .font(.custom("SpaceMono-Bold", size: 17))
                    Divider()
                        .padding(.horizontal)
                        .padding(.top, -10.0)
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
                    .padding(.trailing)
                    .padding(.leading, 20.0)
                    .padding(.top, -17.0)
                    .font(.custom("SpaceMono-Bold", size: 28))
                    @Environment(\.colorScheme) var colorScheme
                    Spacer()
                    BannerView()
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
                }
            }
        }
        .navigationTitle("SETTINGS")
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
