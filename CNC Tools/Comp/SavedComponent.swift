import SwiftUI

struct SavedComponent: View {
    var toolName: String
    var toolDiameter: Double
    var spindelSpeed: Double
    var feedRate: Double
    @State var openStack = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(toolName: String, toolDiameter: Double, spindelSpeed: Double, feedRate: Double) {
        self.toolName = toolName
        self.toolDiameter = toolDiameter
        self.spindelSpeed = spindelSpeed
        self.feedRate = feedRate
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
        VStack(alignment: .leading) {
            Toggle (isOn: $openStack) {
                HStack(alignment: .center) {
                    if openStack {
                        Image(systemName: "chevron.down")
                            .font(Font.system(size: 16))
                    } else {
                        Image(systemName: "chevron.right")
                            .font(Font.system(size: 16))
                    }
                    Text("Ø")
                    Text(twoDigits.string(from: NSNumber(value: toolDiameter)) ?? "")
                    Text(toolName)
                    Spacer()
                }
            }
            .toggleStyle(.button)
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .font(.custom("SpaceMono-Bold", size: 17))
            .textCase(.uppercase)
            .frame(height: 20)
            if openStack {
                HStack(alignment: .center) {
                    Spacer()
                        .frame(width: 36.0)
                    VStack(alignment: .leading) {
                        Text("Spindel speed:")
                        Text(twoDigits.string(from: NSNumber(value: spindelSpeed)) ?? "")
                    }
                    Spacer()
                        .frame(width: 60.0)
                    VStack(alignment: .leading) {
                        Text("Feed rate:")
                        Text(twoDigits.string(from: NSNumber(value: feedRate)) ?? "")
                    }
                }
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .font(.custom("SpaceMono-Bold", size: 13))
                .textCase(.uppercase)
            }
        }
    }
}

struct SavedComponent_Previews: PreviewProvider {
    static var previews: some View {
        SavedComponent(toolName: "Sandvik", toolDiameter: 120.0, spindelSpeed: 1200.0, feedRate: 666).padding()
    }
}
