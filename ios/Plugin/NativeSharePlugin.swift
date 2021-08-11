import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(NativeSharePlugin)
public class NativeSharePlugin: CAPPlugin {
    private let implementation = NativeShare()
    private let store = NativeShareStore.store

    @objc
    func getLastSharedItems(_ call: CAPPluginCall) {
        do {
            try call.resolve(self.implementation.getLastSharedItems())
            
            let options: [String: Any] = call.getObject("options", [:])
            let autoRemove: Bool = ((options["autoRemove"] as? Bool) ?? false ) == true
            
            if (autoRemove == true) {
                store.clear()
            }
        } catch {
            call.reject("No shared detected")
        }
    }
    
    public override func load() {
        NotificationCenter.default.addObserver(self, selector: #selector(sharedReceived), name: Notification.Name("shareReceived"), object: nil)
    }
    
    @objc
    func sharedReceived() -> Void {
        do {
            let data = try self.implementation.getLastSharedItems()
            print(data)
            self.notifyListeners("sharedReceived", data: data)
        } catch {}
    }
    
    @objc
    func clear(_ call: CAPPluginCall) -> Void {
        self.implementation.clearLastSharedItems()
        call.resolve([:])
    }

}
