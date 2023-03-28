import SwiftUI

struct SettingsView: View {
    init() {
            UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFPro-ExpandedMedium", size: 34)!]
        }
    
    // - VARIABLES
    @State var chooseMmOrInch = true    // true - MM, false - INCH
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    switch chooseMmOrInch {
                    case true:
                        Button("MM") {
                            
                        }
                        Text("/")
                        Button("INCH") {
                            
                        }
                        .opacity(0.5)
                    case false:
                        Button("MM") {
                            
                        }
                        .opacity(0.5)
                        Text("/")
                        Button("INCH") {
                            
                        }
                    }
                }
                .font(.custom("SFPro-ExpandedBold", size: 50))
                .foregroundColor(.white)
                Spacer()
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
