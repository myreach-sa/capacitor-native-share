import Foundation

public final class NativeShareStore {
    public var items: [NativeShareItem] = []
    
    public static let store = NativeShareStore()
    
    public init() {
        self.items = []
    }
}
