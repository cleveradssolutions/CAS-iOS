import SwiftUI

struct HomeView: View {
    @State var adContainer: AdContainer?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(AdContainer.allCases, id: \.self) { container in
                        Button {
                            adContainer = container
                        } label: {
                            Text(container.title)
                                .font(.headline)
                                .padding(.vertical, 8)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

                NavigationLink(
                    destination: destinationView(),
                    isActive: Binding(
                        get: { adContainer != nil },
                        set: { newValue in
                            if !newValue { adContainer = nil }
                        }
                    )
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationTitle("Ad Formats")
        }
    }

    @ViewBuilder
    private func destinationView() -> some View {
        if let adContainer {
            adContainer.container
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(adContainer.title)
                .navigationBarTitleDisplayMode(.large)
        } else {
            EmptyView()
        }
    }
}
