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

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    private func sendData() {
        var containerAppUrlExtension: String = self.getContainerAppUrlExtension()
        var urlString: String = containerAppUrlExtension + "://?"
        self.items.forEach { item in
            urlString = item.addItemsToString(urlString)
        }

        print(urlString)

        var url = URL(string: urlString)!
        openURL(url)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []

        Task {
            try await withThrowingTaskGroup(
                of: NativeShareItem.self,
                body: { taskGroup in
                    for (index, attachment) in attachments.enumerated() {
                        print("ATTACHMENT \(index)")

                           if attachment.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                                print("ATTACHMENT CONFORMS TO URL")
                                taskGroup.addTask {
                                    return try await self.urlDataHandler(attachment)
                                }
                            } else if attachment.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                                print("ATTACHMENT CONFORMS TO TEXT")
                                taskGroup.addTask {
                                    return try await self.textDataHandler(attachment)
                                }
                            } else if attachment.hasItemConformingToTypeIdentifier(kUTTypeItem as String) {
                                print("ATTACHMENT CONFORMS TO ITEM")
                                taskGroup.addTask {
                                    return try await self.itemDataHandler(attachment)
                                }
                            }
                    }

                    for try await shareItem in taskGroup {
                        self.items.append(shareItem)
                    }
                }
            )

            self.sendData()
        }
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

    open func itemDataHandler(_ attachment: NSItemProvider) async throws -> NativeShareItem {
        let results = try await attachment.loadItem(forTypeIdentifier: kUTTypeItem as String, options: nil)
        let shareItem = NativeShareItem()
        let url = results as! URL?

        self.handleUrlData(url, shareItem)

        return shareItem
    }

    open func urlDataHandler(_ attachment: NSItemProvider) async throws -> NativeShareItem {
        let results = try await attachment.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil)
        let shareItem = NativeShareItem()
        let url = results as! URL?

        self.handleUrlData(url, shareItem)

        return shareItem
    }

    open func textDataHandler(_ attachment: NSItemProvider) async throws -> NativeShareItem {
        let results = try await attachment.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil)
        let shareItem = NativeShareItem()

        self.handleTextData(results as! String, shareItem)

        return shareItem
    }

    open func handleTextData(_ text: String?, _ shareItem: NativeShareItem) -> Void {
        shareItem.text = text ?? ""
    }

     open func handleUrlData(_ url: URL?, _ shareItem: NativeShareItem) -> Void {
        if (url != nil) {
            if (url?.isFileURL ?? false) {
                do {
                    shareItem.uri = self.createSharedFileUrl(url)
                    shareItem.mimeType = self.getMimeType(url)   
                } catch {
                    print("Error while getting file data")
                }
            } else {
                shareItem.text = url?.absoluteString ?? ""
            }
        }
     }

    open func getMimeType(_ url: URL?) -> String {
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
    
    fileprivate func createSharedFileUrl(_ url: URL?) -> String {
        let fileManager = FileManager.default
        
        let copyFileUrl = fileManager.containerURL(forSecurityApplicationGroupIdentifier: self.getAppGroupIdentifier())!
            .absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + url!
            .lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        try? Data(contentsOf: url!).write(to: URL(string: copyFileUrl)!)
        
        return copyFileUrl
    }
}
