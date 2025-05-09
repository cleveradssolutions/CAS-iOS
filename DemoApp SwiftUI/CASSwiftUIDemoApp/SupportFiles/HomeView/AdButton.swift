import SwiftUI

struct AdButton: View {
    
    let title: String
    let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(12)
        }
    }
}
