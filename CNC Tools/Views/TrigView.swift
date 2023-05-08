import SwiftUI
import CoreData
import GoogleMobileAds
import StoreKit

struct TrigView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(entity: Tool.entity(), sortDescriptors: []) private var metricInches: FetchedResults<Tool>
    @StateObject private var storeKitManager = StoreKitManager()
    @State private var metricInchesCheck = true    // true - MM, false - INCH
    
    @State private var aSide = 0.0
    @State private var bSide = 0.0
    @State private var cSide = 0.0
    
    @State private var aDeg = 0.0
    @State private var bDeg = 0.0
    @State private var cDeg = 0.0
    
    func nonNumberShield() {
        if cSide < aSide {
            bSide = 0.0
            aDeg = 0.0
            bDeg = 0.0
            cDeg = 0.0
        }
    }
    
    func cSideFunc() {
        nonNumberShield()
        cSide = pow(aSide, 2) + pow(bSide, 2)
        cSide = sqrt(cSide)
    }
    func aDegFuncForASide() {
        nonNumberShield()
        aDeg = aSide / cSide
        aDeg = asin(aDeg)
        aDeg = aDeg * 180.0 / Double.pi
    }
    func aDegFuncForBSide() {
        nonNumberShield()
        aDeg = bSide / cSide
        aDeg = asin(aDeg)
        aDeg = aDeg * 180.0 / Double.pi
    }
    func cDegFunc() {
        nonNumberShield()
        cDeg = 180.0 - bDeg - aDeg
    }
    func bSideFunc() {
        nonNumberShield()
        bSide = pow(cSide, 2) - pow(aSide, 2)
        bSide = sqrt(bSide)
    }
    
    var body: some View {
        let sideA = Binding (
            get: { aSide },
            set: { aSide = $0
                if $0 > 0.0 {
                    cSideFunc()
                    aDegFuncForASide()
                    bDeg = 90.0
                    cDegFunc()
                }
            }
        )
        let sideB = Binding (
            get: { bSide },
            set: { bSide = $0
                if $0 > 0.0 {
                    cSideFunc()
                    aDegFuncForBSide()
                    bDeg = 90.0
                    cDegFunc()
                }
            }
        )
        let sideC = Binding (
            get: { cSide },
            set: { cSide = $0
                if $0 > 0.0 {
                    bSideFunc()
                    aDegFuncForASide()
                    bDeg = 90.0
                    cDegFunc()
                }
            }
        )
        let degA = Binding (
            get: { aDeg },
            set: { aDeg = $0
                if $0 > 0.0 {
                   
                }
            }
        )
        let degB = Binding (
            get: { bDeg },
            set: { bDeg = $0
                if $0 > 0.0 {
                   
                }
            }
        )
        let degC = Binding (
            get: { cDeg },
            set: { cDeg = $0
                if $0 > 0.0 {
                   
                }
            }
        )
        
        NavigationView {
            VStack {
                ScrollView (.vertical) {
                    VStack {
                        HStack {
                            Text("Sides")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.blue)
                                .padding(.leading, 30.0)
                            Spacer()
                        }
                        .padding(.bottom, 7.0)
                        HStack {
                            TrigInputComponent(name: "A", inputName: "A", inputValue: sideA)
                            TrigInputComponent(name: "B", inputName: "B", inputValue: sideB)
                            TrigInputComponent(name: "C", inputName: "C", inputValue: sideC)
                        }
                        HStack {
                            Text("Angles")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.blue)
                                .padding(.leading, 30.0)
                            Spacer()
                        }
                        .padding(.bottom, 7.0)
                        .padding(.top)
                        HStack {
                            TrigInputComponent(name: "Alpha", inputName: "α", inputValue: degA)
                            TrigInputComponent(name: "Beta", inputName: "β", inputValue: degB)
                            TrigInputComponent(name: "Gamma", inputName: "γ", inputValue: degC)
                        }
                        VStack(alignment: .center) {
                            Triangle(a: aSide, b: bSide, c: cSide)
                                .stroke(Color.black, lineWidth: 2)
                                .padding()
                                .frame(width: aSide, height: bSide, alignment: .center)
                                .padding(.top, bSide)
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
        .navigationTitle("Triangle")
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

struct Triangle: Shape {
    let a: CGFloat
    let b: CGFloat
    let c: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let p1 = CGPoint(x: 0, y: 0)
        let p2 = CGPoint(x: a, y: 0)
        let p3 = CGPoint(x: 0, y: -b)
        
        path.move(to: p1)
        path.addLine(to: p3)
        path.addLine(to: p2)
        path.closeSubpath()
        
        return path
    }
}

struct TrigView_Previews: PreviewProvider {
    static var previews: some View {
        TrigView()
    }
}
