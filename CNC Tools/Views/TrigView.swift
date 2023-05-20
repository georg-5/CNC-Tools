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
    @State private var bDeg = 90.0
    @State private var cDeg = 0.0
    
    @State private var area = 0.0
    @State private var perimeter = 0.0
    
    func nonNumberShield() {
        if cSide < aSide {
            bSide = 0.0
            aDeg = 0.0
            bDeg = 0.0
            cDeg = 0.0
        } else if aDeg > 90.0 || cDeg > 90.0 {
            aDeg = 45.0
            bDeg = 90.0
            cDeg = 45.0
        }
    }
    
    // A Degrees formula
    func funcADeg() {
        nonNumberShield()
        aDeg = aSide / cSide
        aDeg = asin(aDeg)
        aDeg = aDeg * 180.0 / Double.pi
    }
    func funcADegReturn() {
        let aRad = aDeg * Double.pi / 180.0
        cSide = aSide / sin(aRad)
    }
    // C Degrees formula
    func funcCDeg() {
        nonNumberShield()
        cDeg = 180.0 - bDeg - aDeg
    }
    
    
    // A Side formula
    func funcASide() {
        nonNumberShield()
        aSide = pow(cSide, 2) - pow(bSide, 2)
        aSide = sqrt(aSide)
    }
    // B Side formula
    func funcBSide() {
        nonNumberShield()
        bSide = pow(cSide, 2) - pow(aSide, 2)
        bSide = sqrt(bSide)
    }
    // C Side formula
    func funcCSide() {
        nonNumberShield()
        cSide = pow(aSide, 2) + pow(bSide, 2)
        cSide = sqrt(cSide)
    }
    // Area calculating
    func funcArea() {
        area = 1/2 * aSide * bSide
    }
    // Perimeter calculating
    func funcPerimeter() {
        perimeter = aSide + bSide + cSide
    }
    
    
    var body: some View {
        let sideA = Binding (
            get: { aSide },
            set: { aSide = $0
                if $0 > 0.0 {
                    bDeg = 90.0
                    funcCSide()
                    funcBSide()
                    funcASide()
                    funcADeg()
                    funcCDeg()
                    funcPerimeter()
                    funcArea()
                }
            }
        )
        let sideB = Binding (
            get: { bSide },
            set: { bSide = $0
                if $0 > 0.0 {
                    bDeg = 90.0
                    funcCSide()
                    funcASide()
                    funcBSide()
                    funcADeg()
                    funcCDeg()
                    funcPerimeter()
                    funcArea()
                }
            }
        )
        let sideC = Binding (
            get: { cSide },
            set: { cSide = $0
                if $0 > 0.0 {
                    bDeg = 90.0
                    funcBSide()
                    funcCSide()
                    funcASide()
                    funcADeg()
                    funcCDeg()
                    funcPerimeter()
                    funcArea()
                }
            }
        )
        let degA = Binding (
            get: { aDeg },
            set: { aDeg = $0
                if $0 > 0.0 {
                    bDeg = 90.0
                    funcCDeg()
                    funcADegReturn()
                    funcBSide()
                    funcASide()
                    funcCSide()
                    funcPerimeter()
                    funcArea()
                }
            }
        )
        let degC = Binding (
            get: { cDeg },
            set: { cDeg = $0
                if $0 > 0.0 {
                    bDeg = 90.0
                    funcADeg()
                    aDeg = 180.0 - bDeg - cDeg
                    funcBSide()
                    funcASide()
                    funcCSide()
                    funcPerimeter()
                    funcArea()
                }
            }
        )
        
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Text("Sides")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.blue)
                            .padding(.leading, 30.0)
                        Spacer()
                    }
                    .padding(.bottom, 1.0)
                    HStack {
                        Spacer()
                        TrigInputComponent(name: "Base", inputName: "A", inputValue: sideA)
                        TrigInputComponent(name: "Height", inputName: "B", inputValue: sideB)
                        TrigInputComponent(name: "Hypotenuse", inputName: "C", inputValue: sideC)
                        Spacer()
                    }
                    HStack {
                        Text("Angles")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.blue)
                            .padding(.leading, 30.0)
                        Spacer()
                    }
                    .padding(.bottom, 1.0)
                    .padding(.top)
                    HStack {
                        Spacer()
                        TrigInputComponent(name: "Alpha", inputName: "α", inputValue: degA)
                        HStack {
                            VStack(alignment: .center) {
                                Text("Beta")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.blue)
                                Text("90")
                                    .padding(.top, -15)
                                    .font(.system(size: 27, weight: .bold))
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            }
                        }
                        .padding(.horizontal, 40.0)
                        
                        TrigInputComponent(name: "Gamma", inputName: "γ", inputValue: degC)
                        Spacer()
                    }
                    if aSide > 0.0 {
                        VStack {
                            HStack {
                                VStack(alignment: .center) {
                                    Text("Area")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(.blue)
                                    Text("\(area.removeZerosFromEnd())")
                                        .padding(.top, -15)
                                        .font(.system(size: 27, weight: .bold))
                                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    
                                }
                            }
                            .padding(.horizontal, 40.0)
                            HStack {
                                VStack(alignment: .center) {
                                    Text("Perimeter")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(.blue)
                                    Text("\(perimeter.removeZerosFromEnd())")
                                        .padding(.top, -15)
                                        .font(.system(size: 27, weight: .bold))
                                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                }
                            }
                            .padding(.horizontal, 40.0)
                            .padding(.top)
                            Spacer()
                        }
                        .padding(.top)
                    }
                    Spacer()
                    ZStack {
                        VStack(alignment: .center) {
                            Text("Base (A)")
                                .offset(x: 0, y: 130)
                            Text("Height (B)")
                                .offset(x: -35, y: 145)
                                .rotationEffect(.degrees(90.0))
                            Text("Hypotenuse (C)"   )
                                .offset(x: -35, y: -60)
                                .rotationEffect(.degrees(45.0))
                        }
                        VStack {
                            HStack {
                                Spacer()
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: 0))
                                    path.addLine(to: CGPoint(x: 0, y: 250))
                                    path.addLine(to: CGPoint(x: 250, y: 250))
                                    path.closeSubpath()
                                }
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: 250, height: 250, alignment: .center)
                                .padding()
                                Spacer()
                            }
                            Text("γ").offset(x: 65, y: -60 )
                            Text("β").offset(x: -100, y: -80)
                            Text("α").offset(x: -105, y: -280)
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

struct TrigView_Previews: PreviewProvider {
    static var previews: some View {
        TrigView()
    }
}
