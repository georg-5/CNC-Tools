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
                        Text("Units of measurements")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.leading)
                    .font(.custom("TestSohne-Halbfett", size: 20))
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
                    .padding(.top, -15.0)
                    .padding(.horizontal)
                    .font(.custom("TestSohne-Halbfett", size: 28))
                    .foregroundColor(.black)
                    
                    // MARK: - STORE MANAGER
                    HStack {
                        Text("Buy Premium & Remove ADs")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding([.top, .leading])
                    .font(.custom("TestSohne-Halbfett", size: 20))
                    HStack {
                        if storeKitManager.premiumUnlocked {
                            Text("Premium Unlocked")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        } else {
                            Button("Unlock Premium") {
                                storeKitManager.getProducts()
                                storeKitManager.purchaseProduct()
                            }
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                    .padding(.top, -15.0)
                    .padding(.horizontal)
                    .font(.custom("TestSohne-Halbfett", size: 28))
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
                            .font(Font.custom("TestSohne-Buch", size: 17))
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
