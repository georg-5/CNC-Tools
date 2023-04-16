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
