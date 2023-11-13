//
import CleverAdsSolutions
import SwiftUI

struct ContentView: View {
    // Store CAS Manager in AdViewState
    @StateObject var adViewState: AdViewState

    var body: some View {
        NavigationView {
            List(MenuItem.allCases) { item in
                NavigationLink(
                    destination: item.makeContentView()
                        .navigationTitle(item.rawValue)) {
                    Text(item.rawValue)
                }
            }
            .navigationTitle("Menu")
        }
        // Share AdViewState via environment object to acces from Ad Views
        .environmentObject(adViewState)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            adViewState: AdViewState(
                manager: AppDelegate.createAdManager()
            )
        )
    }
}
