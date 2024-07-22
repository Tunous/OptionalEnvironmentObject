import SwiftUI
import OptionalEnvironmentObject

final class MyObject: ObservableObject {
    @Published var number: Double = 0
}

struct ContentView: View {
    @EnvironmentObject.Optional private var object: MyObject?

    var body: some View {
        if let object {
            Text("Found: \(object.number)")
        } else {
            Text("Not found")
        }
        SliderView()
    }
}

struct SliderView: View {
    @EnvironmentObject.Optional private var object: MyObject?

    var body: some View {
        if let numberBinding = $object?.number {
            Slider(value: numberBinding, in: 0...1).padding(.horizontal)
        }
    }
}
