import Foundation

enum NativeShareError: Error {
    case NO_SHARED_DETECTED
}

@objc public class NativeShare: NSObject {
    @objc public func getLastSharedItems() throws -> Dictionary<String, Any> {
        throw NativeShareError.NO_SHARED_DETECTED
    }
}
