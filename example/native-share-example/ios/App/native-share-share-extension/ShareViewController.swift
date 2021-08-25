import UIKit
import Social
import MobileCoreServices
import ReachCapacitorNativeShare

class ShareViewController: NativeShareExtension {
    override func getContainerAppUrlExtension() -> String {
        return "ReachCapacitorNativeShareExample"
    }
    
    override func getAppGroupIdentifier() -> String {
        return "group.ch.rea.plugins.nativeshareexample"
    }
}
