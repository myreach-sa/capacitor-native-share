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
        
        store.clear()
        
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
    
    @objc
    public static func cleanTemporalFolder(appGroupName: String) -> Void {
        do {
            let appUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)
            guard let tmpUrl = appUrl?.appendingPathComponent("share-tmp") else { return  }
            try FileManager.default.removeItem(at: tmpUrl)
        } catch {
            print("Can't clean temporal folder")
        }
    }
}
