import SwiftUI
import StoreKit

struct MainComponent: View {
    @Environment(\.colorScheme) var colorScheme
    var categoryName: String
    var iconNames: [String]
    var navNames: [String]
    var navViews: [() -> AnyView]
    var stackSize = 42.0
    
    init(categoryName: String, iconNames: [String], navNames: [String], navViews: [ () -> AnyView]) {
        self.categoryName = categoryName
        self.iconNames = iconNames
        self.navNames = navNames
        self.navViews = navViews
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
                    GradientRectangle(cRadius: 3, recIconName: iconNames[index])
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
