import SwiftUI
import StoreKit

struct MainComponent: View {
    @Environment(\.colorScheme) var colorScheme
    var categoryName: String
    var categoryLogo: String
    var navNameColumnOne: [String]
    var navNameColumnTwo: [String]
    var navViewColumnOne: [() -> AnyView]
    var navViewColumnTwo: [() -> AnyView]
    
    init(categoryName: String, categoryLogo: String, navNameColumnOne: [String], navNameColumnTwo: [String], navViewColumnOne: [ () -> AnyView], navViewColumnTwo: [ () -> AnyView]) {
        self.categoryName = categoryName
        self.categoryLogo = categoryLogo
        self.navNameColumnOne = navNameColumnOne
        self.navNameColumnTwo = navNameColumnTwo
        self.navViewColumnOne = navViewColumnOne
        self.navViewColumnTwo = navViewColumnTwo
    }
    
    var body: some View {
        Group {
            HStack(alignment: .center) {
                Text(categoryName)
                    .foregroundColor(.blue)
                Spacer()
            }
            .padding(.leading)
            .font(.custom("TestSohne-Halbfett", size: 20))
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: -5.0) {
                    ForEach(Array(zip(navNameColumnOne, navViewColumnOne)), id: \.0) { navName, navView in
                        NavigationLink(destination: navView()) {
                            Text(navName)
                        }
                    }
                }
                Spacer()
                VStack(alignment: .leading, spacing: -5.0) {
                    ForEach(Array(zip(navNameColumnTwo, navViewColumnTwo)), id: \.0) { navName, navView in
                        NavigationLink(destination: navView()) {
                            Text(navName)
                        }
                    }

                }
                Spacer()
            }
            .padding(.top, -15.0)
            .padding(.horizontal)
            .font(.custom("TestSohne-Halbfett", size: 44))
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        }
    }
}
