import ReachCapacitorNativeShare

class ShareViewController: NativeShareExtension {
    public override func getContainerAppUrlExtension() -> String {
        return "ReachCapacitorNativeShareExample"
    }
}
