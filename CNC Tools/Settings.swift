import SwiftUI
import MessageUI
import StoreKit


struct Settings: View {
    /// # - AppStorage
    @AppStorage("units") var units: Bool = false
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("feedback_style") var sensoryFeedbackStyle: String = "Light"
    /// # - States
    @StateObject var controller = ViewModel()
    /// # - Environments
    @EnvironmentObject private var purchaseManager: IAPManager
    
    /// # - Functions
    private func hapticFeedbacker() {
        if sensoryFeedback {
            switch sensoryFeedbackStyle {
            case controller.hapticStyleArray[0]:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case controller.hapticStyleArray[1]:
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            case controller.hapticStyleArray[2]:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case controller.hapticStyleArray[3]:
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            case controller.hapticStyleArray[4]:
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            default:
                break
            }
        }
        
        if sensoryFeedback {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    /// # - App Section
                    Section {
                        // UNITS
                        Label {
                            Picker("Units", selection: $controller.unitSelection) {
                                ForEach(controller.unitArray, id: \.self) { unit in
                                    Text(unit)
                                }
                            }
                            .onChange(of: controller.unitSelection) { _ in
                                switch controller.unitSelection {
                                case controller.unitArray[0]:
                                    hapticFeedbacker()
                                    units = true
                                default:
                                    hapticFeedbacker()
                                    units = false
                                }
                                if units {
                                    hapticFeedbacker()
                                    controller.unitSelection = controller.unitArray[0]
                                } else {
                                    hapticFeedbacker()
                                    controller.unitSelection = controller.unitArray[1]
                                }
                            }
                        } icon: {
                            Image(systemName: "ruler")
                        }
                        // HAPTIC FEEDBACK
                        Label {
                            Toggle("Haptic Feedback", isOn: $sensoryFeedback)
                                .onChange(of: sensoryFeedback) { _ in
                                    hapticFeedbacker()
                                }
                        } icon: {
                            Image(systemName: "water.waves")
                        }
                        .contextMenu {
                            if sensoryFeedback {
                                ForEach(controller.hapticStyleArray, id: \.self) { menu in
                                    Button {
                                        sensoryFeedbackStyle = menu
                                    } label: {
                                        Text(menu)
                                        Spacer()
                                        if menu == sensoryFeedbackStyle {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                    .onChange(of: sensoryFeedbackStyle) { _ in
                                        hapticFeedbacker()
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("App")
                    }
                    /// # - Account Section
                    Section {
                        // Premium
                        Label {
                            if purchaseManager.hasUnlockedPremium {
                                Text("Premium unlocked!")
                                    .opacity(0.5)
                            } else {
                                if let product = purchaseManager.product {
                                    Button {
                                        Task {
                                            do {
                                                try await purchaseManager.purchase(product)
                                            } catch {
                                                print(error)
                                            }
                                        }
                                        hapticFeedbacker()
                                    } label: {
                                        Text("Unlock premium only for \(product.displayPrice)")
                                    }
                                }
                            }
                        } icon: {
                            Image(systemName: "dollarsign")
                        }
                        // Mail Feedback
                        Label {
                            Link("Share your feedback", destination: URL(string: "https://tally.so/r/woeaYx")!)
                                .foregroundStyle(.white)
                        } icon: {
                            Image(systemName: "envelope")
                        }
                    } header: {
                        Text("Account")
                    } footer: {
                        if purchaseManager.hasUnlockedPremium {
                            Text("Thank you for supporting the development of the app!")
                        } else {
                            Text("By buying premium you will support the development of the app, remove ads and unlock features.")
                        }
                    }
                    /// # - Info
                    Section {
                        Label {
                            HStack {
                                Text("Version")
                                Spacer()
                                Text("\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")")
                                    .opacity(0.5)
                            }
                        } icon: {
                            Image(systemName: "info.circle")
                        }
                    }
                }
            }
            .onAppear {
                if units {
                    controller.unitSelection = controller.unitArray[0]
                } else {
                    controller.unitSelection = controller.unitArray[1]
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            Task {
                do {
                    try await purchaseManager.loadProduct()
                } catch {
                    print(error)
                }
            }
        }
    }
}
