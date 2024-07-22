import SwiftUI

extension EnvironmentObject {
    /// Variant of `EnvironmentObject` property wrapper with support for
    /// optionality.
    ///
    /// Compared to `EnvironmentObject` this property wrapper will return `nil`
    /// instead of crashing application if object of wrapped type is not present
    /// in the environment.
    ///
    /// - Note: For this to work correctly use ``SwiftUI/View/optionalEnvironmentObject(_:)``
    ///   when adding environment objects to view hierarchy.
    ///
    /// ## Example
    ///
    /// ```swift
    /// import SwiftUI
    /// import OptionalEnvironmentObject
    ///
    /// final class MyObject: ObservableObject {}
    ///
    /// struct ContentView: View {
    ///     @EnvironmentObject.Optional private var object: MyObject?
    ///
    ///     var body: some View {
    ///         if let object {
    ///             Text("Found: \(object)")
    ///         } else {
    ///             Text("Not found")
    ///         }
    ///     }
    /// }
    ///
    /// #Preview {
    ///     VStack {
    ///         ContentView()
    ///         ContentView()
    ///             .optionalEnvironmentObject(MyObject())
    ///     }
    /// }
    /// ```
    @propertyWrapper
    public struct Optional: DynamicProperty {
        @EnvironmentObject private var object: ObjectType
        @Environment(\.environmentObjectPresence) private var environmentObjectPresence
        
        /// The underlying value referenced by the environment object.
        @MainActor
        public var wrappedValue: ObjectType? {
            return isEnvironmentObjectPresent ? object : nil
        }

        /// A projection of the environment object that creates bindings to its
        /// properties using dynamic member lookup.
        @MainActor
        public var projectedValue: EnvironmentObject<ObjectType>.Wrapper? {
            return isEnvironmentObjectPresent ? $object : nil
        }

        /// Creates an optional environment object.
        public init() {}

        private var isEnvironmentObjectPresent: Bool {
            environmentObjectPresence.contains(ObjectIdentifier(ObjectType.self))
        }
    }
}

extension View {
    /// Supplies an observable object to a view’s hierarchy. This should be used
    /// if you want to optionally access environment objects using
    /// ``SwiftUI/EnvironmentObject/Optional`` property wrapper.
    ///
    /// - Parameter object: The object to store and make available to the view’s hierarchy.
    public func optionalEnvironmentObject<T: ObservableObject>(_ object: T) -> some View {
        self.environmentObject(object)
            .transformEnvironment(\.environmentObjectPresence) { presence in
                presence.insert(ObjectIdentifier(T.self))
            }
    }
}

// MARK: - Internal

private struct EnvironmentObjectPresenceKey: EnvironmentKey {
    static let defaultValue: Set<ObjectIdentifier> = []
}

extension EnvironmentValues {
    fileprivate var environmentObjectPresence: Set<ObjectIdentifier> {
        get { self[EnvironmentObjectPresenceKey.self] }
        set { self[EnvironmentObjectPresenceKey.self] = newValue }
    }
}
