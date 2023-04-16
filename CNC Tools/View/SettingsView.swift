import SwiftUI
import CoreData
import StoreKit

struct SettingsView: View {
    // MARK: - VARIABLES
    @State private var chooseMmOrInch: Bool = true  // true - MM, false - INCH
    @StateObject private var storeKitManager = StoreKitManager()
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
                    // MARK: - UNITS
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
                    
                    // MARK: - STORE MANAGER
                    HStack {
                        Image(systemName: "bag")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        Text("REMOVE AD AND BUY NEW FEATURES")
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top, 5)
                    .font(.custom("SpaceMono-Bold", size: 17))
                    Divider()
                        .padding(.horizontal)
                        .padding(.top, -10.0)
                    HStack {
                        if storeKitManager.premiumUnlocked {
                            Text("PREMIUM UNLOCKED")
                        } else {
                            Button("ULOCK PREMIUM") {
                                storeKitManager.getProducts()
                                storeKitManager.purchaseProduct()
                            }
                        }
                    }
                    .padding(.trailing)
                    .padding(.leading, 20.0)
                    .padding(.top, -17.0)
                    .font(.custom("SpaceMono-Bold", size: 28))
                    Spacer()
                    if storeKitManager.premiumUnlocked == false {
                        BannerView()
                            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
                    }
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
            SKPaymentQueue.default().add(storeKitManager)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
