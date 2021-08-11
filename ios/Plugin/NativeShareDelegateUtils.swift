import UIKit
import Foundation

@objc public class NativeShareDelegateUtils: NSObject {
    @objc
    public static func handleApplicationUrl(app: UIApplication, url: URL, store: NativeShareStore) -> Bool {
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let params = components.queryItems else {
            print("params not found")
            return false
        }
        
        let textList: [String] = params.filter { $0.name == "reachCNS_text" } .map { $0.value ?? "" }
        let mimeTypeList: [String] = params.filter { $0.name == "reachCNS_mimeType" } .map { $0.value ?? "" }
        let uriList: [String] = params.filter { $0.name == "reachCNS_uri" } .map { $0.value ?? "" }
        
        print("TEXT")
        textList.forEach { print($0) }
        
        print("MIMETYPE")
        mimeTypeList.forEach { print($0) }
        
        print("URI")
        uriList.forEach { print($0) }
        
        for (idx, _) in textList.enumerated() {
            let text = textList[idx]
            let mimeType = mimeTypeList[idx]
            let uri = uriList[idx]
            
            let item = NativeShareItem(text: text, uri: uri, mimeType: mimeType)
            store.items.append(item)
        }
        
        NotificationCenter.default.post(name: Notification.Name("shareReceived"), object: nil )
        
        return true
    }
}
