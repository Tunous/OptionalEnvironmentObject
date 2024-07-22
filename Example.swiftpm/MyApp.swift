import SwiftUI
import OptionalEnvironmentObject

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                ContentView()
                ContentView()
                    .optionalEnvironmentObject(MyObject())
            }
        }
    }
}
