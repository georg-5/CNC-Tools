import SwiftUI
import CoreData
import GoogleMobileAds
import StoreKit


struct ThreadView: View {
    
    // MARK: - Variables
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(entity: Tapping.entity(), sortDescriptors: []) private var tapType: FetchedResults<Tapping>
    @StateObject private var storeKitManager = StoreKitManager()
    @State private var metricInchesCheck = true    // true - MM, false - INCH
    @State private var exOrIn = true // true - Internal, false - External
    
    // MARK: - Functions
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

    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("What type do you need?")
                        .foregroundColor(.blue)
                    Spacer()
                }
                .padding(.leading)
                .font(.custom("TestSohne-Halbfett", size: 20))
                HStack {
                    Button("Internal") {
                        exOrIn = true
                        updateMetricInches()
                    }
                    .opacity(chooseMmOrInch ? 1.0 : 0.3)
                    Text("/")
                    Button("External") {
                        exOrIn = false
                    }
                    .opacity(chooseMmOrInch ? 0.3 : 1.0)
                }
                .padding(.leading, 30.0)
                .padding(.top, -1.0)
                .font(.custom("TestSohne-Halbfett", size: 28))
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                Spacer()
                if storeKitManager.premiumUnlocked == false {
                    BannerView()
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    HStack {
                        Button("Done") {
                            
                        }
                        Button {
                            
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        Button {
                            
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                    }
                }
            }
            .padding(.top, 10.0)
        }
        .navigationTitle("Tapping")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "chevron.left")
                            .font(Font.system(size: 16))
                        Text("Back")
                            .font(Font.custom("TestSohne-Buch", size: 17))
                    }
                }
            }
        }
        .onAppear {
            if let metricInchesCored = metricInches.first {
                metricInchesCheck = metricInchesCored.mmOrInch
            }
            SKPaymentQueue.default().add(storeKitManager)
        }
        .onReceive(storeKitManager.$product) { product in
            if let _ = product {
                storeKitManager.purchaseProduct()
            }
        }
        .onTapToDismissKeyboard()
        
    }
}

// MARK: - Simulator Preview
struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadView()
    }
}
