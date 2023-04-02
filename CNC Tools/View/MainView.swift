import SwiftUI
import CoreData
import GoogleMobileAds
import StoreKit

// MARK: - CLASSES
class AppState: ObservableObject {
    @Published var metricInchesCheck = true
}
class ReviewManager: ObservableObject {
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func showReviewAlertAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 300) {
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
            print("Ошибка при подсчете суммы значений в CoreData: \(error)")
            return 0.0
        }
    }
    private func autoDismissAlert() {
            Task {
                await Task.sleep(UInt64(1 * 1_000_000_000)) // 3 секунды
                DispatchQueue.main.async {
                    showAlertForSavedTool = false
                }
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
                            autoDismissAlert()
                        }, label: {
                            Image(systemName: "rectangle.stack")
                        })
                        .fullScreenCover(isPresented: $showAlertForSavedTool, content: {
                            AlertComponent(showAlertComp: showAlertForSavedTool)
                                    })
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
