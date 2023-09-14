import SwiftUI
import UIKit
import Firebase
import FirebaseFirestore

enum RegimesTabs: String, CaseIterable {
    case milling
    case turning
    case drilling
}

enum TrigonometryTabs: String, CaseIterable {
    case triangle
}

enum OtherTabs: String, CaseIterable {
    case tools
    case chamfer
}

struct Main: View {
    /// # - AppStorage
    @AppStorage("units") var units: Bool = false // MM - false ; Inch - true
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("feedback_style") var sensoryFeedbackStyle: String = "Light"
    @AppStorage("launches") var launches = 0
    
    /// # - Variables
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    /// # - States
    @StateObject var viewModel = ViewModel()
    @State var viewSelected: String = ""
    @State var sheetOpen: Bool = false
    @State var whatsNewSheet: Bool = false
    
    @ObservedObject var whatsNewViewModel = WhatsNewViewModel()
    
    /// # - Environments
    @EnvironmentObject private var purchaseManager: IAPManager
    @Environment(\.requestReview) var requestReview
    @Environment(\.scenePhase) var scenePhase
    
    /// # - Functions
    func hapticFeedbacker() {
        if sensoryFeedback {
            switch sensoryFeedbackStyle {
            case viewModel.hapticStyleArray[0]:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case viewModel.hapticStyleArray[1]:
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            case viewModel.hapticStyleArray[2]:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case viewModel.hapticStyleArray[3]:
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            case viewModel.hapticStyleArray[4]:
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            default:
                break
            }
        }
    }
    // FIREBASE
    func signIn() {
        Auth.auth().signInAnonymously { authResult, error in
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    // # - Header
                    HStack {
                        if purchaseManager.hasUnlockedPremium {
                            Text("CNC TOOLS+")
                                .foregroundStyle(.black)
                                .textCase(.uppercase)
                                .font(.custom("SFPro-Bold", size: 17))
                        } else {
                            Text("CNC TOOLS")
                                .foregroundStyle(.black)
                                .textCase(.uppercase)
                                .font(.custom("SFPro-Bold", size: 17))
                        }
                        Spacer()
                        Button {
                            whatsNewSheet.toggle()
                        } label: {
                            Image(systemName: "newspaper")
                                .foregroundStyle(.black)
                                .font(.custom("SFPro-Regular", size: 17))
                        }
                        .padding(.horizontal, 10)
                        .sheet(isPresented: $whatsNewSheet) {
                            if #available(iOS 16.4, *) {
                                WhatsNewSheet()
                                    .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.fraction(0.7)])
                            } else {
                                WhatsNewSheet()
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.fraction(0.7)])
                            }
                        }
                        Button {
                            hapticFeedbacker()
                            viewModel.openSettingsView = true
                        } label: {
                            Image(systemName: "gear")
                                .foregroundStyle(.black)
                                .font(.custom("SFPro-Regular", size: 17))
                        }
                        .sheet(isPresented: $viewModel.openSettingsView) {
                            if #available(iOS 16.4, *) {
                                Settings(controller: viewModel)
                                    .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                    .presentationDragIndicator(.hidden)
                                    .presentationDetents([.fraction(0.7)])
                            } else {
                                Settings()
                                    .presentationDragIndicator(.hidden)
                                    .presentationDetents([.fraction(0.7)])
                            }
                        }
                    }
                    .padding(.all)
                    .background(Color.mint.clipShape(.rect(cornerRadius: viewModel.cornerRadius)))
                    PremiumBanner()
                    HStack {
                        Text("Regimes calculator")
                            .font(.custom("SFPro-Bold", size: 25))
                        Spacer()
                    }
                    .padding(.all)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(RegimesTabs.allCases, id: \.rawValue) { tab in
                            Button {
                                withAnimation(.bouncy) {
                                    viewSelected = tab.rawValue
                                    sheetOpen = true
                                }
                            } label: {
                                TabView(name: tab.rawValue, color: .orange)
                            }
                        }
                    }
                    HStack {
                        Text("Trigonometry")
                            .font(.custom("SFPro-Bold", size: 25))
                        if !purchaseManager.hasUnlockedPremium {
                            Image(systemName: "sparkles")
                                .font(.system(size: 25))
                                .foregroundStyle(.yellow)
                        }
                        Spacer()
                    }
                    .padding(.all)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(TrigonometryTabs.allCases, id: \.rawValue) { tab in
                            Button {
                                withAnimation(.bouncy) {
                                    viewSelected = tab.rawValue
                                    sheetOpen = true
                                }
                            } label: {
                                TabView(name: tab.rawValue, color: .mint)
                            }
                        }
                    }
                    HStack {
                        Text("Other")
                            .font(.custom("SFPro-Bold", size: 25))
                        if !purchaseManager.hasUnlockedPremium {
                            Image(systemName: "sparkles")
                                .font(.system(size: 25))
                                .foregroundStyle(.yellow)
                        }
                        Spacer()
                    }
                    .padding(.all)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(OtherTabs.allCases, id: \.rawValue) { tab in
                            Button {
                                withAnimation(.bouncy) {
                                    viewSelected = tab.rawValue
                                    sheetOpen = true
                                }
                            } label: {
                                TabView(name: tab.rawValue, color: .blue)
                            }
                        }
                    }
                }
                .sheet(isPresented: $sheetOpen) {
                    switch viewSelected {
                    case "milling":
                        if #available(iOS 16.4, *) {
                            MillingView(viewModel: viewModel)
                                .onAppear() {
                                    hapticFeedbacker()
                                }
                                .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                .interactiveDismissDisabled()
                                .presentationDragIndicator(.hidden)
                        } else {
                            MillingView()
                                .onAppear() {
                                    hapticFeedbacker()
                                }
                                .interactiveDismissDisabled()
                                .presentationDragIndicator(.automatic)
                        }
                    case "turning":
                        if #available(iOS 16.4, *) {
                            TurningView()
                                .onAppear() {
                                    hapticFeedbacker()
                                }
                                .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                .interactiveDismissDisabled()
                                .presentationDragIndicator(.hidden)
                        } else {
                            TurningView()
                                .onAppear() {
                                    hapticFeedbacker()
                                }
                                .interactiveDismissDisabled()
                                .presentationDragIndicator(.hidden)
                        }
                    case "drilling":
                        if #available(iOS 16.4, *) {
                            DrillingView()
                                .onAppear() {
                                    hapticFeedbacker()
                                }
                                .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                .interactiveDismissDisabled()
                                .presentationDragIndicator(.hidden)
                        } else {
                            DrillingView()
                                .onAppear() {
                                    hapticFeedbacker()
                                }
                                .interactiveDismissDisabled()
                                .presentationDragIndicator(.hidden)
                        }
                    case "triangle":
                        if purchaseManager.hasUnlockedPremium {
                            if #available(iOS 16.4, *) {
                                TrigView()
                                    .onAppear() {
                                        hapticFeedbacker()
                                    }
                                    .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            } else {
                                TrigView()
                                    .onAppear() {
                                        hapticFeedbacker()
                                    }
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            }
                        } else {
                            if #available(iOS 16.4, *) {
                                PremiumSheet()
                                    .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            } else {
                                PremiumSheet()
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            }
                        }
                    case "tools":
                        if purchaseManager.hasUnlockedPremium {
                            if #available(iOS 16.4, *) {
                                SavedTools()
                                    .onAppear() {
                                        hapticFeedbacker()
                                    }
                                    .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            } else {
                                SavedTools()
                                    .onAppear() {
                                        hapticFeedbacker()
                                    }
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            }
                        } else {
                            if #available(iOS 16.4, *) {
                                PremiumSheet()
                                    .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            } else {
                                PremiumSheet()
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            }
                        }
                    case "chamfer":
                        if purchaseManager.hasUnlockedPremium {
                            if #available(iOS 16.4, *) {
                                ChamferView()
                                    .onAppear() {
                                        hapticFeedbacker()
                                    }
                                    .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            } else {
                                ChamferView()
                                    .onAppear() {
                                        hapticFeedbacker()
                                    }
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            }
                        } else {
                            if #available(iOS 16.4, *) {
                                PremiumSheet()
                                    .presentationCornerRadius(viewModel.cornerRadius * 1.5)
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            } else {
                                PremiumSheet()
                                    .interactiveDismissDisabled()
                                    .presentationDragIndicator(.hidden)
                            }
                        }
                    default:
                        EmptyView()
                    }
                }
            }
            .padding(.all)
            .task(id: scenePhase) {
                guard scenePhase  == .active else {
                    return
                }
                await purchaseManager.updatePurchasedProducts()
                signIn()
                if launches != 0 {
                    let vote = Int.random(in: 1...10)
                    print("Vote: \(vote)")
                    switch vote {
                    case 5:
                        requestReview()
                    default:
                        break
                    }
                } else if launches == 0 {
                    whatsNewSheet = true
                }
                launches += 1
                print("Launches: \(launches)")
            }
        }
    }
}
