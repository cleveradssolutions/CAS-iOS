//

import SwiftUI

struct AdCallbacksView: View {
    @ObservedObject var model = AdCallbacksViewModel()

    var body: some View {
        Section {
            ForEach(model.list) {
                Text($0.name)
            }
        } header: {
            Text("Ad callback list")
        }
    }

    struct Item: Identifiable {
        let id = UUID()
        let name: String
    }
}
