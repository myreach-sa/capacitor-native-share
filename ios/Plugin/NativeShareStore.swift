import Foundation

public final class NativeShareStore {
    public var items: [NativeShareItem] = []
    
    public static let store = NativeShareStore()
    
    private init() {
        self.items = []
    }
    
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
    
    public func clear() -> Void {
        self.items = []
    }
}
