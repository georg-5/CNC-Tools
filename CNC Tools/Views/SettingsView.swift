import SwiftUI
import CoreData
import StoreKit
import GoogleMobileAds
import MessageUI

struct SettingsView: View {
    // MARK: - Variables
    @State private var chooseMmOrInch: Bool = true  // true - MM, false - INCH
    @StateObject private var storeKitManager = StoreKitManager()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(entity: Tool.entity(), sortDescriptors: []) private var tools: FetchedResults<Tool>
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false

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
            HStack {
                VStack(alignment: .leading) {
                    //MARK: - Units
                    HStack {
                        Text("Units of measurements")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .font(.system(size: 20, weight: .bold))
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
                    .padding(.leading)
                    .padding(.top, -1.0)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                    // MARK: - Premium
                    HStack {
                        Text("Buy Premium & Remove ADs")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.top)
                    .font(.system(size: 20, weight: .bold))
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
                    .padding(.top, -1)
                    .padding(.leading)
                    .font(.system(size: 28, weight: .bold))
                    Spacer()
                    //MARK: - Contact form
                    HStack {
                        Spacer()
                        VStack {
                            if MFMailComposeViewController.canSendMail() {
                                Button("Report a bug / Suggest a feature") {
                                    self.isShowingMailView.toggle()
                                }
                            } else {
                                Text("Can't send emails from this device")
                            }
                            if result != nil {
                                Text("Result: \(String(describing: result))")
                                    .lineLimit(nil)
                            }
                        }
                        .sheet(isPresented: $isShowingMailView) {
                            MailView(isShowing: self.$isShowingMailView, result: self.$result)
                        }
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top, -1.0)
                    .padding(.bottom)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.blue)
                    if storeKitManager.premiumUnlocked == false {
                        BannerView()
                            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
                    }
                }
                .padding(.leading, 30.0)
            }
        }
        .navigationTitle("Settings")
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
            if let tool = tools.first {
                chooseMmOrInch = tool.mmOrInch
            }
            SKPaymentQueue.default().add(storeKitManager)
        }
        .onReceive(storeKitManager.$product) { product in
            if let _ = product {
                storeKitManager.purchaseProduct()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
