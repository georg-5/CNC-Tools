import SwiftUI
import CoreData
import GoogleMobileAds
import StoreKit

// MARK: - CLASSES
class AppState: ObservableObject {
    @Published var metricInchesCheck = true
}
class ReviewManager: ObservableObject {
    private let appLaunchCountKey = "appLaunchCount"
    private let nextRequestReviewCountKey = "nextRequestReviewCount"
    private let minimumLaunchesBeforeReview = 3
    private let additionalLaunchesBeforeReview = 5

    init() {
        incrementLaunchCount()
    }

    private func incrementLaunchCount() {
        let currentCount = UserDefaults.standard.integer(forKey: appLaunchCountKey)
        UserDefaults.standard.set(currentCount + 1, forKey: appLaunchCountKey)
    }

    private func shouldRequestReview() -> Bool {
        let currentCount = UserDefaults.standard.integer(forKey: appLaunchCountKey)
        let nextRequestReviewCount = UserDefaults.standard.integer(forKey: nextRequestReviewCountKey)

        if currentCount >= nextRequestReviewCount {
            UserDefaults.standard.set(currentCount + additionalLaunchesBeforeReview, forKey: nextRequestReviewCountKey)
            return true
        }

        return false
    }

    func requestReview() {
        if shouldRequestReview(),
           let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    func showReviewAlertAfterDelay() {
        if UserDefaults.standard.integer(forKey: nextRequestReviewCountKey) == 0 {
            UserDefaults.standard.set(minimumLaunchesBeforeReview, forKey: nextRequestReviewCountKey)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 800) {
            self.requestReview()
        }
    }
}

// MARK: - MAIN VIEW
struct MainView: View {
    // MARK: - INIT
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "TestSohne-Halbfett", size: 17)!]
        }
    
    // MARK: - VARIABLES
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
    
    // MARK: - FUNCTIONS
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

    var body: some View {
        NavigationView {
            HStack {
                VStack {
                    // 1ST ROW
                    MainComponent(categoryName: "Regimes Calculating",
                                  categoryLogo: "number",
                                  navNameColumnOne: ["Milling", "Turning"],
                                  navNameColumnTwo: ["Drilling"],
                                  navViewColumnOne: [{ AnyView(MillingView()) }, { AnyView(TurningView()) }],
                                  navViewColumnTwo: [{ AnyView(DrillingView()) }]
                    )
                    Spacer().frame(height: 30)
                    /*
                     // 2ND ROW
                     MainComponent(categoryName: "TRIGONOMETRY",
                     categoryLogo: "angle",
                     navNameColumnOne: ["RECTANGULAR"],
                     navNameColumnTwo: [],
                     navViewColumnOne: [{ AnyView(TriangleView()) }],
                     navViewColumnTwo: []
                     )
                     Spacer().frame(height: 40)
                     */
                    // 3RD ROW
                    HStack(alignment: .center) {
                        Text("Others")
                        Spacer()
                    }
                    .padding(.leading)
                    .font(.custom("TestSohne-Halbfett", size: 20))
                    .foregroundColor(.blue)
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: -5.0) {
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
                        }
                        Spacer()
                        /* VStack(alignment: .center, spacing: -5.0) {
                         
                         }
                         Spacer()
                         */
                    }
                    .padding(.top, -15.0)
                    .padding(.horizontal)
                    .font(.custom("TestSohne-Halbfett", size: 44))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
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
            .navigationTitle("CNC TOOLS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    HStack(alignment: .center) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 17, height: 17)
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - SIMULATOR PREVIEW
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
