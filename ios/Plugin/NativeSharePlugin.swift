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

    @objc func getLastSharedItems(_ call: CAPPluginCall) {
        do {
            try call.resolve(self.implementation.getLastSharedItems())
        } catch {
            call.reject("No shared detected")
        }
    }
    
    public override func load() {
        NotificationCenter.default.addObserver(self, selector: #selector(sharedReceived), name: Notification.Name("shareReceived"), object: nil)
    }
    
    @objc func sharedReceived() -> Void {
        do {
            let data = try self.implementation.getLastSharedItems()
            print(data)
            self.notifyListeners("sharedReceived", data: data)
        } catch {}
    }

}
