import SwiftUI

struct GradientRectangle: View {
    @State private var gradient: Gradient = randomGradient()
    var cRadius = CGFloat()
    var recIconName = String()
    
    init(cRadius: CGFloat, recIconName: String) {
        self.cRadius = cRadius
        self.recIconName = recIconName
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cRadius)
            .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(
                Image(recIconName)
                    .resizable()
                    .frame(maxWidth: .infinity, minHeight: 19)
                )
            .onAppear {
                self.gradient = Self.randomGradient()
            }
    }

    static func randomGradient() -> Gradient {
        let colors = [
            Color(.sRGB, red: Double.random(in: 0..<1), green: Double.random(in: 0..<1), blue: Double.random(in: 0..<1), opacity: 0.7),
            Color(.sRGB, red: Double.random(in: 0..<1), green: Double.random(in: 0..<1), blue: Double.random(in: 0..<1), opacity: 0.7)
        ]
        return Gradient(colors: colors)
    }
}
