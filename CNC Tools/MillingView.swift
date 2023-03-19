import SwiftUI

struct MillingView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Milling")
                    .padding([.top, .leading, .bottom])
                    .font(.custom("SFPro-ExpandedMedium", size: 34))
                Spacer()
            }
            Spacer()
        }
        .padding(.leading, 14.0)
    }
}

struct MillingView_Previews: PreviewProvider {
    static var previews: some View {
        MillingView()
    }
}
