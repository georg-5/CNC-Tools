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
    // MARK: - VARIABLES
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tool.mmOrInch, ascending: true)],
                  animation: .default)
    private var metricInches: FetchedResults<Tool>
    @StateObject private var appState = AppState()
    @StateObject private var reviewManager = ReviewManager()
    @State private var showAlert = false
    @State private var showAlertForSavedTool = false
    
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
            VStack {
                BannerView()
                    .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
                Spacer().frame(height: 190.0)
                VStack {
                    NavigationLink(destination: MillingView()) {
                        Text("MILLING")
                    }
                    NavigationLink(destination: TurningView()) {
                        Text("TURNING")
                    }
                    NavigationLink(destination: DrillingView()) {
                        Text("DRILLING")
                    }
                    Divider()
                    NavigationLink(destination: TriangleView()) {
                        Text("TRIANGLE")
                    }
                }
                .font(.custom("SFPro-ExpandedHeavy", size: 50))
                HStack(spacing: 25.0) {
                    if checkValuesInCoreData() {
                        NavigationLink(destination: SavedToolsView()) {
                            Image(systemName: "rectangle.stack")
                        }
                    } else {
                        Button(action: {
                            showAlertForSavedTool = true
                        }, label: {
                            Image(systemName: "rectangle.stack")
                        })
                        .alert(isPresented: $showAlertForSavedTool) {
                                Alert(
                                    title: Text("No saved tools yet!")
                                )
                            }
                    }
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                }
                .padding(.top)
                .font(.system(size: 30))
                Spacer()
                Text("CNC TOOLS")
                    .font(.custom("SFPro-ExpandedUltraLight", size: 15))
            }
            .foregroundColor(.white)
            .onAppear {
                reviewManager.showReviewAlertAfterDelay()
                if let metricInchesCored = metricInches.first {
                    appState.metricInchesCheck = metricInchesCored.mmOrInch
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
