import SwiftUI
import CoreData
import GoogleMobileAds
import StoreKit

struct MainView: View {
    
    // MARK: - Variables
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tool.mmOrInch, ascending: true)],
                  animation: .default)
    private var metricInches: FetchedResults<Tool>
    @StateObject private var storeKitManager = StoreKitManager()
    @StateObject private var appState = AppState()
    @StateObject private var reviewManager = ReviewManager()
    @State private var showAlert = false
    @State private var showAlertForSavedTool = false
    @State private var showAlertForPremium = false
    @State var sSizes = 42.0
    
    // MARK: - Functions
    private func checkValuesInCoreData() -> Bool {
           let sumOuterDiameter = sumOfAttribute("outerDiameter")
           let sumToolDiameterMills = sumOfAttribute("toolDiameterMill")
           let sumToolDiameterDrills = sumOfAttribute("toolDiameterDrill")
           
           return sumOuterDiameter > 0.0 || sumToolDiameterMills > 0.0 || sumToolDiameterDrills > 0.0
       }
    private func sumOfAttribute(_ attributeName: String) -> Double {
        let keyPathExpression = NSExpression(forKeyPath: attributeName)
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [keyPathExpression])
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Tool")
        fetchRequest.resultType = .dictionaryResultType
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "sum"
        sumExpressionDescription.expression = sumExpression
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        
        fetchRequest.propertiesToFetch = [sumExpressionDescription]
        
        do {
            let results = try viewContext.fetch(fetchRequest) as? [NSDictionary]
            let sum = results?.first?["sum"] as? Double ?? 0.0
            return sum
        } catch {
            print("Error: \(error)")
            return 0.0
        }
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            HStack {
                VStack {
                    // 1ST ROW
                    MainComponent(categoryName: "Regimes Calculating",
                                  iconNames: ["Milling", "Turning", "Drilling"],
                                  navNames: ["Milling", "Turning", "Drilling"],
                                  navViews: [{ AnyView(MillingView()) },
                                                     { AnyView(TurningView()) },
                                                     { AnyView(DrillingView()) }]
                    )
                    // 2ND ROW
                    MainComponent(categoryName: "Geometry",
                                  iconNames: ["", ""],
                                  navNames: ["Triangle", "Сircle"],
                                  navViews: [{ AnyView(TrigView()) },
                                                     { AnyView(ToleranceView()) }]
                    )
                    // 3RD ROW
                    HStack(alignment: .center) {
                        Text("Others")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top, -15.0)
                    VStack(alignment: .leading, spacing: 5.0) {
                        HStack(alignment: .center) {
                            GradientRectangle(cRadius: 3, recIconName: "Tools")
                                .frame(width: sSizes + 8.0, height: sSizes + 8.0)
                            if storeKitManager.premiumUnlocked {
                                if checkValuesInCoreData() {
                                    NavigationLink(destination: SavedToolsView()) {
                                        Text("Saved Tools")
                                    }
                                } else {
                                    Button(action: {
                                        showAlertForSavedTool = true
                                    }, label: {
                                        Text("Saved Tools")
                                    })
                                    .alert(isPresented: $showAlertForSavedTool) {
                                        Alert(
                                            title: Text("No saved tools yet!")
                                        )
                                    }
                                }
                            } else {
                                Button(action: {
                                    showAlertForPremium = true
                                }, label: {
                                    Text("Saved Tools")
                                })
                                .alert(isPresented: $showAlertForPremium) {
                                    Alert(
                                        title: Text("You need to unlock this feature!")
                                    )
                                }
                            }
                            Spacer()
                        }
                        .font(.system(size: sSizes, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                    .padding(.leading, 30.0)
                    .padding(.top, -2.0)
                    Spacer()
                    if storeKitManager.premiumUnlocked == false {
                        BannerView()
                            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
                    }
                }
            }
            .onAppear {
                reviewManager.showReviewAlertAfterDelay()
                if let metricInchesCored = metricInches.first {
                    appState.metricInchesCheck = metricInchesCored.mmOrInch
                }
                SKPaymentQueue.default().add(storeKitManager)
            }
            .onReceive(storeKitManager.$product) { product in
                if let _ = product {
                    storeKitManager.purchaseProduct()
                }
            }
            .navigationTitle("CNC Tools")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem {
                    HStack(alignment: .center) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Simulator Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
