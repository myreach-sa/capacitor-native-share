import Foundation

@objc
public class NativeShareItem: NSObject {
    @objc
    public var text: String = ""
    
    @objc
    public var uri: String = ""
    
    @objc
    public var mimeType: String = ""
    
    @objc
    public override init() {}
    
    @objc
    public init(text: String = "", uri: String = "", mimeType: String = "") {
        self.text = text
        self.uri = uri
        self.mimeType = mimeType
    }
    
    @objc
    public func addItemsToString(_ url: String) -> String {
        var ret: String = url
        ret = self.addParamToUrl(url: ret, param: "reachCNS_text", value: self.text)
        ret = self.addParamToUrl(url: ret, param: "reachCNS_uri", value: self.uri)
        ret = self.addParamToUrl(url: ret, param: "reachCNS_mimeType", value: self.mimeType)
        return ret
    }
    
    private func addParamToUrl(url: String, param: String, value: String) -> String {
        let encodedValue: String = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let encodedParam: String = param.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        return url + "&" + encodedParam + "=" + encodedValue
    }
}
