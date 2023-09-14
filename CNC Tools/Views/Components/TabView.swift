import SwiftUI

struct TabView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var name: String
    var color: Color
    
    init(name: String, color: Color) {
        self.name = name
        self.color = color
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(name)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .multilineTextAlignment(.leading)
                    .opacity(0.8)
                Spacer()
            }
            HStack {
                Spacer()
                Text(name)
                    .font(.custom("SFPro-Bold", size: 17))
                    .textCase(.uppercase)
                    .multilineTextAlignment(.trailing)
            }
        }
        .foregroundStyle(Color.black)
        .padding(.all)
        .padding(.horizontal, 7.5)
        .frame(width: 170)
        .background(color.clipShape(.rect(cornerRadius: viewModel.cornerRadius)))
        .padding(.horizontal, 5)
    }
}

#Preview {
    TabView(name: "milling", color: .orange)
}
