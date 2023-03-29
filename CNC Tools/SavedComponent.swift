import SwiftUI

struct SavedComponent: View {
    var toolName: String
    var toolDiameter: Double
    var spindelSpeed: Double
    var feedRate: Double
    @State var openStack: Bool
    
    init(toolName: String, toolDiameter: Double, spindelSpeed: Double, feedRate: Double, openStack: Bool) {
        self.toolName = toolName
        self.toolDiameter = toolDiameter
        self.spindelSpeed = spindelSpeed
        self.feedRate = feedRate
        self.openStack = openStack
    }
    let twoDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        return formatter
     }()
    
    var body: some View {
        VStack {
            Button {
                openStack = true
            } label: {
                if openStack {
                    Image(systemName: "chevron.down")
                } else {
                    Image(systemName: "chevron.right")
                }
                HStack {
                    Text("Ø \(toolDiameter)")
                    Text(toolName)
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .font(.custom("SFPro-ExpandedSemiBold", size: 14))
            if openStack {
                HStack {
                    Text("Spindel speed: \(spindelSpeed)")
                    Text("Feed rate: \(feedRate)")
                }
                .foregroundColor(.white)
                .font(.custom("SFPro-ExpandedRegular", size: 13))
            }
        }
    }
}

struct SavedComponent_Previews: PreviewProvider {
    static var previews: some View {
        SavedComponent(toolName: "Name", toolDiameter: 0.0, spindelSpeed: 0.0, feedRate: 0.0, openStack: false).padding()
    }
}
