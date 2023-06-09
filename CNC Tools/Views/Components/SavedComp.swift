import SwiftUI

struct SavedComponent: View {
    var toolName: String
    var toolDiameter: Double
    var spindelSpeed: Double
    var feedRate: Double
    var mmInch: String
    @State var openStack = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(toolName: String, toolDiameter: Double, spindelSpeed: Double, feedRate: Double, mmInch: String) {
        self.toolName = toolName
        self.toolDiameter = toolDiameter
        self.spindelSpeed = spindelSpeed
        self.feedRate = feedRate
        self.mmInch = mmInch
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
                        .font(.system(size: 15))
                    Text(twoDigits.string(from: NSNumber(value: toolDiameter)) ?? "")
                        .padding(.leading, -3.0)
                    Text(toolName)
                    Spacer()
                }
            }
            .toggleStyle(.button)
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .font(.system(size: 17, weight: .bold))
            .textCase(.uppercase)
            .frame(height: 20)
            if openStack {
                HStack(alignment: .center) {
                    Spacer()
                        .frame(width: 36.0)
                    VStack(alignment: .leading) {
                        Text("Spindel speed:")
                        HStack(alignment: .bottom) {
                            Text(twoDigits.string(from: NSNumber(value: spindelSpeed)) ?? "")
                            Text("rpm")
                                .font(.caption2)
                                .foregroundColor(Color.blue)
                        }
                    }
                    Spacer()
                        .frame(width: 60.0)
                    VStack(alignment: .leading) {
                        Text("Feed rate:")
                        HStack(alignment: .bottom) {
                            Text(twoDigits.string(from: NSNumber(value: feedRate)) ?? "")
                            Text(mmInch)
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.top, 5.0)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .font(.system(size: 13, weight: .bold))
                .textCase(.uppercase)
            }
        }
    }
}

struct SavedComponent_Previews: PreviewProvider {
    static var previews: some View {
        SavedComponent(toolName: "Sandvik", toolDiameter: 120.0, spindelSpeed: 1200.0, feedRate: 666, mmInch: "mm/min").padding()
    }
}
