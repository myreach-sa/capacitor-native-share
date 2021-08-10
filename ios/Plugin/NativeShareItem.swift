public class NativeShareItem {
    public var text: String = ""
    public var uri: String = ""
    public var mimeType: String = ""
    
    public init() {}
    
    public init(text: String = "", uri: String = "", mimeType: String = "") {
        self.text = text
        self.uri = uri
        self.mimeType = mimeType
    }
    
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
