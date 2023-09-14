import Combine
import FirebaseAuth
import Foundation
import SwiftUI
import FirebaseFirestore

struct Post: Identifiable {
    var id = UUID().uuidString
    var name: String
    var description: String
    var postDate: String
    var link: String
}

class WhatsNewViewModel: ObservableObject {
    @Published var post = [Post]()
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("post").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.post = documents.map { (queryDocumentSnapshot) -> Post in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let postDate = data["postDate"] as? String ?? ""
                let link = data["link"] as? String ?? ""
                return Post(name: name, description: description, postDate: postDate, link: link)
            }
        }
    }
}

struct WhatsNewSheet: View {
    
    @StateObject var viewModel = ViewModel()
    @StateObject var whatsNewViewModel = WhatsNewViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Text("What's new?")
                    .font(.custom("SFPro-Bold", size: 25))
                    .foregroundStyle(.white)
                    .padding(.top)
                    .padding([.leading, .top, .trailing])
                    .padding(.horizontal)
                List(whatsNewViewModel.post) { post in
                    VStack(alignment: .leading) {
                        Text(post.postDate)
                            .font(.custom("SFPro-Regular", size: 15))
                            .foregroundStyle(.gray)
                        Text(post.name)
                            .font(.custom("SFPro-Bold", size: 25))
                            .foregroundStyle(.white)
                        Text(post.description)
                            .font(.custom("SFPro-Regular", size: 20))
                            .foregroundStyle(.gray)
                        VStack(alignment: .center) {
                            HStack(alignment: .center) {
                                Spacer()
                                AsyncImage(url: URL(string: post.link)) { image in
                                    image
                                        .image?.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 220)
                                }
                                .clipShape(.rect(cornerRadius: viewModel.cornerRadius))
                                .padding(.all)
                                Spacer()
                            }
                        }
                        .background(Color.gray
                            .opacity(0.2)
                            .clipShape(.rect(cornerRadius: viewModel.cornerRadius))
                            .frame(height: 250))
                        .padding(.bottom)
                    }
                    .listRowBackground(Color.black)
                }
                .listStyle(.plain)
                .background(.black)
                .scrollContentBackground(.hidden)
            }
        }
        .onAppear() {
            whatsNewViewModel.fetchData()
        }
    }
}

#Preview {
    WhatsNewSheet()
}
