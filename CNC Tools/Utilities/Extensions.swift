import SwiftUI

// HIDE KEYBOARD BY TAPPING ON SCREEN
extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func onTapToDismissKeyboard() -> some View {
        self.onTapGesture {
            self.endEditing()
        }
    }
}

// ZERO FORMAT
extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2 // maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}

