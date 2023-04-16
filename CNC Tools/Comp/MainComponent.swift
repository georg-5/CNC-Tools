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
                Spacer()
                Text(categoryName)
                Spacer()
            }
            .font(.custom("SpaceMono-Bold", size: 17))
            Divider()
                .padding(.horizontal)
                .padding(.top, -10.0)
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .center, spacing: -5.0) {
                    ForEach(Array(zip(navNameColumnOne, navViewColumnOne)), id: \.0) { navName, navView in
                        NavigationLink(destination: navView()) {
                            Text(navName)
                        }
                    }
                }
                Spacer()
                VStack(alignment: .center, spacing: -5.0) {
                    ForEach(Array(zip(navNameColumnTwo, navViewColumnTwo)), id: \.0) { navName, navView in
                        NavigationLink(destination: navView()) {
                            Text(navName)
                        }
                    }

                }
                Spacer()
            }
            .padding(.trailing)
            .padding(.leading, 20.0)
            .padding(.top, -17.0)
            .font(.custom("SpaceMono-Bold", size: 28))
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        }
    }
}
