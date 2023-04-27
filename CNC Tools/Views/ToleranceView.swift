import SwiftUI
import CoreData
import GoogleMobileAds
import StoreKit


struct ToleranceView: View {
    
    // MARK: - Variables
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(entity: Tool.entity(), sortDescriptors: []) private var metricInches: FetchedResults<Tool>
    @StateObject private var storeKitManager = StoreKitManager()
    @State private var metricInchesCheck = true    // true - MM, false - INCH
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                ScrollView (.vertical) {
                    VStack() {
                    }
                    .padding(.leading, 30.0)
                }
                .scrollDismissesKeyboard(.immediately)
                if storeKitManager.premiumUnlocked == false {
                    BannerView()
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
                }
            }
            .padding(.top, 5)
        }
        .navigationTitle("Tolerances")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "chevron.left")
                        Text("Back")
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


struct ToleranceView_Previews: PreviewProvider {
    static var previews: some View {
        ToleranceView()
    }
}
