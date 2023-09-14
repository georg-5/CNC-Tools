import Foundation
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var cornerRadius: CGFloat = 25
    @Published var openSettingsView: Bool = false
    @Published var unitSelection: String = "MM"
    @Published var unitArray: [String] = ["MM", "INCH"]
    @Published var showAlert: Bool = false
    @Published var toolName: String = ""
    @Published var unit: String = ""
    @Published var hapticStyleSelection: String = "Light"
    @Published var hapticStyleArray: [String] = ["Light", "Medium", "Heavy", "Rigid", "Soft"]
    @Published var badNews: [String] = ["No tools in your treasure trove yet.",
                                        "Your toolkit appears to be on a break.",
                                        "Looks like your tool shelf is having a quiet moment.",
                                        "Your toolbelt is experiencing a tool-less voyage.",
                                        "Your toolkit seems to be taking a siesta.",
                                        "Your toolshed is in need of some company.",
                                        "Your tool collection is practicing social distancing.",
                                        "Your toolbox is in need of some new companions.",
                                        "Your toolkit's feeling a bit lonely. Let's introduce it to some tools!",
                                        "Your workshop's awaiting its next magical tool.",
                                        "It seems you haven't saved any tools just yet."]
}
