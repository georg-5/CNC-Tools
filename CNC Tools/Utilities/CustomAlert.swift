import SwiftUI

struct CustomAlert: View {
    var title: String
    var subTitle: String
    var inputName: String
    @Binding var input: String
    
    @StateObject var viewModel = ViewModel()
    
    var firstButtonName: String
    var firstButtonAction: () -> ()
    
    var secondButtonName: String
    var secondButtonAction: () -> ()
    
    init(title: String, subTitle: String, inputName: String, input: Binding<String>, firstButtonName: String, firstButtonAction: @escaping () -> Void, secondButtonName: String, secondButtonAction: @escaping () -> Void) {
        self.title = title
        self.subTitle = subTitle
        self.inputName = inputName
        _input = input
        self.firstButtonName = firstButtonName
        self.firstButtonAction = firstButtonAction
        self.secondButtonName = secondButtonName
        self.secondButtonAction = secondButtonAction
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .onTapGesture {
                    withAnimation(.smooth) {
                        firstButtonAction()
                    }
                }
            VStack(alignment: .center) {
                Text(title)
                    .foregroundStyle(.white)
                    .font(.custom("SFPro-Bold", size: 22))
                Text(subTitle)
                    .foregroundStyle(.white)
                    .font(.custom("SFPro-Regular", size: 13))
                    .padding(.bottom, 8)
                    .padding(.top, 0)
                Divider()
                TextField(inputName, text: $input)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .onSubmit(of: .text) {
                        withAnimation(.smooth) {
                            secondButtonAction()
                        }
                    }
                Divider()
                HStack(alignment: .center) {
                    Spacer()
                    Button {
                        withAnimation(.smooth) {
                            firstButtonAction()
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(firstButtonName)
                                .padding(.top, 7)
                                .foregroundStyle(.red)
                                .font(.custom("SFPro-Bold", size: 17))
                            Spacer()
                        }
                    }
                    Spacer()
                    Divider()
                        .padding(.leading, -9)
                        .frame(height: 30)
                    Spacer()
                    Button {
                        withAnimation(.smooth) {
                            secondButtonAction()
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(secondButtonName)
                                .padding(.top, 7)
                                .foregroundStyle(.white)
                                .font(.custom("SFPro-Regular", size: 17))
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
            .padding(.all)
            .frame(width: 300)
            .background(.ultraThinMaterial)
            .cornerRadius(viewModel.cornerRadius / 2)
        }
    }
}
