import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(NativeSharePlugin)
public class NativeSharePlugin: CAPPlugin {
    private let implementation = NativeShare()

    @objc func getLastSharedItems(_ call: CAPPluginCall) {
        do {
            try call.resolve(implementation.getLastSharedItems())
        } catch {
            call.reject("No shared detected")
        }
    }
}
