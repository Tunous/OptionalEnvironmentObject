# OptionalEnvironmentObject

A way to access SwiftUI EnvironmentObject in a safe way without crashing application.

## Usage

```swift
import SwiftUI
import OptionalEnvironmentObject

final class MyObject: ObservableObject {}

struct ContentView: View {
    @EnvironmentObject.Optional private var object: MyObject?
    
    var body: some View {
        if let object {
            Text("Found: \(object)")
        } else {
            Text("Not found")
        }
    }
}

#Preview {
    VStack {
        ContentView()
        ContentView()
            .optionalEnvironmentObject(MyObject())
    }
}
```

## Installation

### Swift Package Manager

Add the following to the dependencies array in your "Package.swift" file:

```swift
.package(url: "https://github.com/Tunous/OptionalEnvironmentObject", .upToNextMajor(from: "1.0.0"))
```

Or add https://github.com/Tunous/OptionalEnvironmentObject, to the list of Swift packages for any project in Xcode.
