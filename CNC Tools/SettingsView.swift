import SwiftUI

struct SettingsView: View {
    @State var chooseMM = true
    @State var chooseINCH = false
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if chooseMM == true {
                    Button(action: {
                        chooseMM = true
                        chooseINCH = false
                        
                    }) {
                        Text("MM")
                    }
                } else {
                    Text("MM")
                        .opacity(0.5)
                }
                Text("/")
                Button("INCH") {
                    
                }
                
            }
            .font(.custom("SFPro-ExpandedBold", size: 50))
            .foregroundColor(.white)
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
