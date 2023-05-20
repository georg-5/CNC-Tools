import SwiftUI
import StoreKit

struct MainComponent: View {
    @Environment(\.colorScheme) var colorScheme
    var categoryName: String
    var iconNames: [String]
    var navNames: [String]
    var navViews: [() -> AnyView]
    var stackSize = 42.0
    var gradients: [Gradient]
    
    init(categoryName: String, iconNames: [String], navNames: [String], navViews: [() -> AnyView], gradients: [Gradient]) {
        self.categoryName = categoryName
        self.iconNames = iconNames
        self.navNames = navNames
        self.navViews = navViews
        self.gradients = gradients
    }
    
    
    
    var body: some View {
        HStack(alignment: .center) {
            Text(categoryName)
                .foregroundColor(.blue)
            Spacer()
        }
        .padding(.leading)
        .font(.system(size: 20, weight: .bold))
        VStack(alignment: .leading, spacing: 5.0) {
            ForEach(0..<navNames.count, id: \.self) { index in
                HStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 3.0)
                        .fill(LinearGradient(gradient: gradients[index], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .overlay(
                            Image(iconNames[index])
                                .resizable()
                                .frame(maxWidth: .infinity, minHeight: 19)
                            )
                        .frame(width: stackSize + 8.0, height: stackSize + 8.0)
                    NavigationLink(destination: navViews[index]) {
                        Text(navNames[index])
                        Spacer()
                    }
                    .font(.system(size: stackSize, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            }
        }
        .padding(.leading, 30.0)
        .padding(.top, -1.0)
    }
}



