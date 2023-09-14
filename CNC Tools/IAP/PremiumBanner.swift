import SwiftUI
import ConfettiSwiftUI

struct PremiumBanner: View {
    @EnvironmentObject private var purchaseManager: IAPManager
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            if !purchaseManager.hasUnlockedPremium {
                Button {
                    if let product = purchaseManager.product {
                        Task {
                            do {
                                try await purchaseManager.purchase(product)
                            } catch {
                                print(error)
                            }
                        }
                    }
                } label: {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            Text("CNC Tools")
                                .font(.custom("SFPro-Bold", size: 28))
                                .foregroundColor(.black)
                            + Text("+")
                                .font(.custom("SFPro-Bold", size: 28))
                                .foregroundColor(.red)
                                Spacer()
                        }
                        .padding(.bottom, 5)
                        Text("Unlock premium features and support the development!")
                            .font(.custom("SFPro-Light", size: 12))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.all)
                    .background(Color.white)
                    .cornerRadius(viewModel.cornerRadius)
                }
            }
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

#Preview {
    PremiumBanner()
}
