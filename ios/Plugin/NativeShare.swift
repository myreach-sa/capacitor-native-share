import Foundation

enum NativeShareError: Error {
    case NO_SHARED_DETECTED
}

@objc
public class NativeShare: NSObject {
    public var nativeStore = NativeShareStore.store
    
    @objc
    public func getLastSharedItems() throws -> Dictionary<String, Any> {
        let ret = nativeStore.getAsDictionary()
        let length: Int = (ret["length"] as! Int?) ?? 0
        if (length == 0) {
            throw NativeShareError.NO_SHARED_DETECTED
        }
        return ret
    }
    
    @objc
    public func clearLastSharedItems() -> Void {
        nativeStore.clear()
    }
}
