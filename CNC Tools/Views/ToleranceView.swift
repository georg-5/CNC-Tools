import SwiftUI
import CoreData

// MARK: - MILLING VIEW
struct ToleranceView: View {
    // MARK: - VARIABLES
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack {
                BannerView()
                    .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottomTrailing)
            }
        }
        .navigationTitle("TOLERANCES")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(Font.system(size: 16))
                        Text("Back")
                            .font(Font.custom("SpaceMono-Regular", size: 17))
                    }
                }
            }
        }
    }
}

// MARK: - SIMULATOR PREVIEW
struct ToleranceView_Previews: PreviewProvider {
    static var previews: some View {
        ToleranceView()
    }
}
