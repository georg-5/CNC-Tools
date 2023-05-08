import SwiftUI
import CoreData
import GoogleMobileAds
import StoreKit


struct ThreadView: View {
    
    // MARK: - Variables
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(entity: Tool.entity(), sortDescriptors: []) private var metricInches: FetchedResults<Tool>
    @StateObject private var storeKitManager = StoreKitManager()
    @State private var metricInchesCheck = true    // true - MM, false - INCH
    
    @State private var threadSelection1 = 0
    @State private var threadSelection2 = 0
    @State private var threadSelection3 = 0
    @State private var threadSelection4 = 0
    
    private var typeThread: [String] {
        Set(
            metricThreads
                .map { $0.type }
        )
        .sorted()
    }
    private var tapThread: [String] {
        Set(
            metricThreads
                .filter { $0.type == typeThread[threadSelection1] }
                .map { $0.tap }
        )
        .sorted()
    }
    private var sizeThread: [String] {
        Set(
            metricThreads
                .filter { $0.type == typeThread[threadSelection1] }
                .filter { $0.tap == tapThread[threadSelection2] }
                .map { $0.size }
        )
        .sorted()
    }
    private var pitchThread: [Double] {
        Set(
            metricThreads
                .filter { $0.type == typeThread[threadSelection1] }
                .filter { $0.tap == tapThread[threadSelection2] }
                .filter { $0.size == sizeThread[threadSelection3] }
                .map { $0.pitch }
        )
        .sorted()
    }
    private var drillThread: [Double] {
        Set(
            metricThreads
                .filter { $0.type == typeThread[threadSelection1] }
                .filter { $0.tap == tapThread[threadSelection2] }
                .filter { $0.size == sizeThread[threadSelection3] }
                .map { $0.tapDrillSize }
        )
        .sorted()
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                ScrollView (.vertical) {
                    VStack {
                        HStack {
                            Picker("Choose thread type", selection: $threadSelection1) {
                                ForEach(0 ..< typeThread.count, id: \.self) { index in
                                    Text(typeThread[index])
                                }
                            }
                            .pickerStyle(.inline)
                            Picker("Choose thread", selection: $threadSelection2) {
                                ForEach(0 ..< tapThread.count, id: \.self) { index in
                                    Text(tapThread[index])
                                }
                            }
                            .pickerStyle(.inline)
                            Picker("Choose size", selection: $threadSelection3) {
                                ForEach(0 ..< sizeThread.count, id: \.self) { index in
                                    Text(sizeThread[index])
                                }
                            }
                            .pickerStyle(.inline)
                        }
                        HStack {
                            Spacer()
                            Text(pitchThread.map { String($0) }.joined(separator: ", "))
                            Spacer()
                            Text(drillThread.map { String($0) }.joined(separator: ", "))
                            Spacer()
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                if storeKitManager.premiumUnlocked == false {
                    BannerView()
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
                }
            }
            .padding(.top, 5)
        }
        .navigationTitle("Tapping")
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
            if let metricInchesCored = metricInches.first {
                metricInchesCheck = metricInchesCored.mmOrInch
            }
            SKPaymentQueue.default().add(storeKitManager)
        }
        .onReceive(storeKitManager.$product) { product in
            if let _ = product {
                storeKitManager.purchaseProduct()
            }
        }
        .onTapToDismissKeyboard()
    }
}

struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadView()
    }
}
