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
    
    // MARK: - FUNCTIONS
    private func checkValuesInCoreData() -> Bool {
        let outDiamPred = NSPredicate(format: "outerDiameter != nil")
        let toolDiamMillPred = NSPredicate(format: "toolDiameterMill != nil")
        let toolDiamDrillPred = NSPredicate(format: "toolDiameterDrill != nil")
        let sumPred = NSCompoundPredicate(orPredicateWithSubpredicates: [outDiamPred, toolDiamMillPred, toolDiamDrillPred])
            
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Tool.fetchRequest()
        fetchRequest.predicate = sumPred
        do {
            let count = try viewContext.count(for: fetchRequest)
                return count > 0
        } catch {
            return false
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
                            
                        }, label: {
                            Image(systemName: "rectangle.stack")
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
