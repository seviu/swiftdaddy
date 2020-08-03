import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollViewReader in
                LazyVStack(alignment: .leading) {
                    ForEach(1...100, id: \.self) {
                        Text("Row \($0)")
                    }
                    Button("Scroll to the middle") {
                        scrollViewReader.scrollTo(50) // ←------ new ScrollViewReader
                    }
                }
            }
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())
