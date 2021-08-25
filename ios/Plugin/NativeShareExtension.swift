import UIKit
import Social
import MobileCoreServices
import Foundation

@objc open class NativeShareExtension: SLComposeServiceViewController {
    private var items: [NativeShareItem] = []
    
    /**
Override this function with the URL Extension of your app.
     
[More info](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app)
     */
    @objc
    open func getContainerAppUrlExtension() -> String {
        return "ReachCapacitorNativeShareExample"
    }
    
    @objc
    open func getAppGroupIdentifier() -> String {
        return "group.ch.rea.plugins.nativeshareexample"
    }
    
    func getAppGroupUrl() -> URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.getAppGroupIdentifier())
    }

    open override func didSelectPost() {
        let containerAppUrlExtension: String = self.getContainerAppUrlExtension()
        var urlString: String = containerAppUrlExtension + "://?"
        self.items.forEach { item in
            urlString = item.addItemsToString(urlString)
        }
        
        print(urlString)
        
        let url = URL(string: urlString)!
        _ = openURL(url)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    open override func viewDidLoad() {
        print("BEFORE SUPER VIEWDIDLOAD")
        super.viewDidLoad()
        print("AFTER SUPER VIEWDIDLOAD")

        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        
        print("ATTACHMENTS")
        print(attachments as Any)
        
        for attachment in attachments {
            
            print("ATTACHMENT")
            print(attachment)
            
            attachment.loadItem(forTypeIdentifier: kUTTypeItem as String, options: nil, completionHandler: self.urlDataHandler)
            
            attachment.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler:self.textDataHandler)
            
        }
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.didSelectPost), userInfo: nil, repeats: false)

    }
    
    @objc open func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    
    open func urlDataHandler(_ item: NSSecureCoding?, _ error: Error?) -> Void {
        if (item != nil) {
            let shareItem = NativeShareItem()
            self.handleUrlData(item as? NSURL, shareItem)
            self.items.append(shareItem)
        }
    }
    
    open func textDataHandler(_ item: NSSecureCoding?, _ error: Error?) -> Void {
        if (item != nil) {
            let shareItem = NativeShareItem()
            self.handleTextData(item as? NSString, shareItem)
            self.handleUrlData(item as? NSURL, shareItem)
            self.items.append(shareItem)
        }
    }
    
    open func handleUrlData(_ url: NSURL?, _ shareItem: NativeShareItem) -> Void {
        if (url != nil) {
            if url?.isFileURL ?? false {
                do {
                    var cleanUrlPath = "share-tmp/"
                    var tmpUrlPath = url?.path ?? ""
                    if (tmpUrlPath.first == "/") {
                        tmpUrlPath.remove(at: tmpUrlPath.startIndex)
                    }
                    cleanUrlPath.append(tmpUrlPath)
                    
                    let appUrl = self.getAppGroupUrl()
                    let toPath = appUrl?.appendingPathComponent(cleanUrlPath)
                    
                    var uri = url?.absoluteString ?? ""
                    
                    do {
                        try FileManager.default.createDirectory(at: (toPath?.deletingLastPathComponent())!, withIntermediateDirectories: true, attributes: nil)
                        try FileManager.default.copyItem(at: (url?.absoluteURL)!, to: (toPath?.absoluteURL)!)
                        
                        uri = toPath?.absoluteString ?? ""
                    } catch {}
                    
                    shareItem.uri = uri
                    shareItem.mimeType = self.getMimeType(url)
                }
            } else {
                shareItem.text = url?.absoluteString ?? ""
            }
        }
    }
    
    open func handleTextData(_ text: NSString?, _ shareItem: NativeShareItem) -> Void {
        if (text != nil) {
            shareItem.text = text as String? ?? ""
        }
    }
    
    open func getMimeType(_ url: NSURL?) -> String {
        if (url == nil) {
            return ""
        }
        let pathExtension = url?.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}
