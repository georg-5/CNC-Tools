import SwiftUI

struct AlertComponent: View {
    init() {
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }
    @State var showAlertComp: Bool = true
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "exclamationmark.octagon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Text("No saved tools yet!")
                    .font(.custom("SFPro-ExpandedRegular", size: 14))
                    .padding(.top, 20.0)
            }
            .frame(width: 200, height: 200)
            .padding()
            .background(Color.gray.opacity(0.4))
            .cornerRadius(25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .color(Color.clear)
    }
}

struct AlertComponent_Previews: PreviewProvider {
    static var previews: some View {
        AlertComponent()
    }
}
