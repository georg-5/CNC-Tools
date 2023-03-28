import SwiftUI


struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    NavigationLink(destination: MillingView()) {
                        Text("MILLING")
                    }
                    Text("TURNING")
                    Text("DRILLING")
                }
                .font(.custom("SFPro-ExpandedHeavy", size: 50))
                HStack(spacing: 25.0) {
                    Image(systemName: "rectangle.stack")
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
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
