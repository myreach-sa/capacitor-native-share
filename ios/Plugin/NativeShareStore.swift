import Foundation

@objc
public final class NativeShareStore: NSObject {
    @objc
    public var items: [NativeShareItem] = []
    
    @objc
    public static let store = NativeShareStore()
    
    private override init() {
        self.items = []
    }
    
    @objc
    public func getAsDictionary() -> [String: Any] {
        var itemsDictionary: [String: [String: String]] = [:]
        
        for (index, item) in self.items.enumerated() {
            let currentItemDictionary: [String: String] = [
                "text": item.text,
                "mimeType": item.mimeType,
                "uri": item.uri
            ]
            itemsDictionary[String(index)] = currentItemDictionary
        }
        
        return [
            "length": self.items.count,
            "items": itemsDictionary
        ]
    }
    
    @objc
    public func clear() -> Void {
        self.items = []
    }
}
