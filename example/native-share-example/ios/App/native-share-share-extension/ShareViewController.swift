import UIKit
import Social
import MobileCoreServices
import ReachCapacitorNativeShare

class ShareViewController: NativeShareExtension {
    override func getContainerAppUrlExtension() -> String {
        return "ReachCapacitorNativeShareExample"
    }
}
