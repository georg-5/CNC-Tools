import SwiftUI
import SwipeActions

struct SavedComponent: View {
    /// # - AppStorage
    @AppStorage("feedback") var sensoryFeedback: Bool = false
    @AppStorage("feedback_style") var sensoryFeedbackStyle: String = "Light"
    /// # - Variables
    var toolName: String
    var toolDiameter: Double
    var spindelSpeed: Double
    var feedRate: Double
    var mmInch: String
    var tools: FetchedResults<Tool>
    /// # - States
    @State var openStack = false
    @StateObject var controller = ViewModel()
    /// # - Environments
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    /// # - Init
    init(toolName: String, toolDiameter: Double, spindelSpeed: Double, feedRate: Double, mmInch: String, tools: FetchedResults<Tool>) {
        self.toolName = toolName
        self.toolDiameter = toolDiameter
        self.spindelSpeed = spindelSpeed
        self.feedRate = feedRate
        self.mmInch = mmInch
        self.tools = tools
    }
    /// # - Formatter
    let twoDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        return formatter
     }()
    /// # - Functions
    private func hapticFeedbacker() {
        if sensoryFeedback {
            switch sensoryFeedbackStyle {
            case controller.hapticStyleArray[0]:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case controller.hapticStyleArray[1]:
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            case controller.hapticStyleArray[2]:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case controller.hapticStyleArray[3]:
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            case controller.hapticStyleArray[4]:
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            default:
                break
            }
        }
    }
    func getToolByName(_ name: String) -> Tool? {
        return tools.first { $0.toolNameMills == name || $0.toolNameTurns == name || $0.toolNameDrills == name }
    }

    var body: some View {
        SwipeView {
            VStack(alignment: .leading) {
                Toggle(isOn: $openStack) {
                    HStack(alignment: .center) {
                        if openStack {
                            Image(systemName: "chevron.down")
                                .font(.custom("SFPro-Bold", size: 12))
                        } else {
                            Image(systemName: "chevron.right")
                                .font(.custom("SFPro-Bold", size: 12))
                        }
                        Image("diameter")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 12, height: 12)
                        Text(twoDigits.string(from: NSNumber(value: toolDiameter)) ?? "")
                            .font(.custom("SFPro-Bold", size: 17))
                            .padding(.leading, -3.0)
                        Text(toolName)
                            .font(.custom("SFPro-Bold", size: 17))
                            .padding(.leading)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
                .onChange(of: openStack) { _ in
                    hapticFeedbacker()
                }
                .toggleStyle(.button)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .textCase(.uppercase)
                if openStack {
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Spindel speed:")
                                .font(.custom("SFPro-Regular", size: 12))
                            HStack(alignment: .top) {
                                Text(twoDigits.string(from: NSNumber(value: spindelSpeed)) ?? "")
                                    .font(.custom("SFPro-Bold", size: 17))
                                Text("rpm")
                                    .font(.custom("SFPro-Regular", size: 10))
                                    .foregroundColor(Color.blue)
                            }
                        }
                        Spacer()
                            .frame(width: 60.0)
                        VStack(alignment: .leading) {
                            Text("Feed rate:")
                                .font(.custom("SFPro-Regular", size: 12))
                            HStack(alignment: .top) {
                                Text(twoDigits.string(from: NSNumber(value: feedRate)) ?? "")
                                    .font(.custom("SFPro-Bold", size: 17))
                                Text(mmInch)
                                    .font(.custom("SFPro-Regular", size: 10))
                                    .foregroundColor(.blue)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 5.0)
                    .padding(.bottom, 5)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .textCase(.uppercase)
                }
            }
        } trailingActions: { _ in
            SwipeAction("\(Image(systemName: "trash"))") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if let toolToDelete = getToolByName(toolName) {
                        viewContext.delete(toolToDelete)
                        do {
                            try viewContext.save()
                        } catch {
                            fatalError("Unresolved error \(error.localizedDescription)")
                        }
                    }
                }
            }
            .allowSwipeToTrigger()
            .foregroundStyle(Color.white)
            .background(Color.red)
        }
        .swipeActionsStyle(.mask)
        .swipeActionCornerRadius(0)
        .swipeActionsMaskCornerRadius(0)
    }
}
