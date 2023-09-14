import SwiftUI

struct SplashScreen: View {
    @State var isActive = false
    @State var size = 0.8
    @State var opacity = 0.8
    @State var rotation = 0.0
    
    var body: some View {
        if isActive {
            Main()
        } else {
            VStack {
                ZStack {
                    Color.black
                        .ignoresSafeArea(.all)
                    VStack {
                        Image(systemName: "gearshape")
                            .font(.system(size: 150))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(rotation))
                    }
                    .scaleEffect(size)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1)) {
                            self.size = 1
                            self.rotation = 720
                        }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
