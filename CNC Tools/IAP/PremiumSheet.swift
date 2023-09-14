import SwiftUI

struct PremiumSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var purchaseManager: IAPManager
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(.all)
            VStack(alignment: .center) {
                /// # Header
                Spacer()
                ZStack {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(.black)
                        .font(.system(size: 80))
                        .padding(.all)
                    Image(systemName: "plus")
                        .foregroundStyle(.orange)
                        .font(.system(size: 30))
                        .padding(.leading, 85)
                        .padding(.bottom, 85)
                }
                HStack(alignment: .center) {
                    Text("CNC Tools +")
                        .font(.custom("SFPro-Bold", size: 28))
                        .foregroundStyle(.black)
                    Spacer()
                }
                .padding(.horizontal)
                Text("Unlock a world of cutting-edge features to supercharge your productivity!")
                    .font(.custom("SFPro-Regular", size: 17))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                HStack(alignment: .center) {
                    Image("tools")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.black)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: viewModel.cornerRadius / 2)
                            .stroke(.black, lineWidth: 2)
                            .frame(width: 50, height: 50))
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Save tools")
                            .font(.custom("SFPro-Bold", size: 27))
                            .foregroundColor(.black)
                        Text("Save cutting modes & tools for easy access.")
                            .font(.custom("SFPro-Regular", size: 10))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal, 12.5)
                .padding(.all)
                HStack(alignment: .center) {
                    Image("triangle")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.black)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: viewModel.cornerRadius / 2)
                            .stroke(.black, lineWidth: 2)
                            .frame(width: 50, height: 50))
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Solve triangle")
                            .font(.custom("SFPro-Bold", size: 27))
                            .foregroundColor(.black)
                        Text("Solve right triangles easily – find angles, sides, and more.")
                            .font(.custom("SFPro-Regular", size: 10))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal, 12.5)
                .padding(.horizontal)
                HStack(alignment: .center) {
                    Image("chamfer")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.black)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: viewModel.cornerRadius / 2)
                            .stroke(.black, lineWidth: 2)
                            .frame(width: 50, height: 50))
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Calc chamfer")
                            .font(.custom("SFPro-Bold", size: 27))
                            .foregroundColor(.black)
                        Text("Effortlessly determine chamfer dimensions and pathways.")
                            .font(.custom("SFPro-Regular", size: 10))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal, 12.5)
                .padding(.all)
                Spacer()
                Button {
                    if let product = purchaseManager.product {
                        Task {
                            do {
                                try await purchaseManager.purchase(product)
                            } catch {
                                print(error)
                            }
                            dismiss()
                        }
                    }
                } label: {
                    Text("Buy premium")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Capsule()
                            .foregroundStyle(.black))
                }
                .padding(.horizontal)
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.black)
                        .bold()
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Capsule()
                            .stroke(.black))
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.all)
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
    PremiumSheet()
}
