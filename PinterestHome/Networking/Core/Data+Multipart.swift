//
//  Data+Multipart.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 11/03/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation

public struct MultipartBodyItem {
    
    // Properties
    let data: Data
    let mimeType: MIMEType
    let headers: [HTTPHeader]
    
    public init(data: Data, mimeType: MIMEType, headers:[HTTPHeader]) {
        self.data = data
        self.mimeType = mimeType
        self.headers = headers
    }
}

extension MultipartBodyItem: DataEncodable {
    public func endodeToData() throws -> Data {
        return Data()
    }
}

// MARK: - MIME Type Data Helpers
extension Data {
    
    public init(multipartItems: [MultipartBodyItem], boundary: String) {
        var data = Data()
        
        // Adding the multi part items
        for item in multipartItems {
            data.appendMultipartItem(item: item, boundary: boundary)
        }
        // Adding the final Boundary
        data.appendStringLine(string: "--\(boundary)--")
        self.init(referencing: data as NSData)
    }
    public init?(parameters: JSONDictionary, boundary: String) throws {
        
        var data = Data()
        
        for (key, value) in parameters {
            data.appendStringLine(string: "--\(boundary)")
            let httpHeader = HTTPHeader.contentDisposition(formKey: key)
            data.appendStringLine(string: "\(httpHeader.key): \(httpHeader.requestHeaderValue)")
            data.appendNewLine()
            try data.append(JSONSerialization.data(withJSONObject: value, options: .prettyPrinted))
            data.appendNewLine()
        }
        data.appendStringLine(string: "--\(boundary)--")

        self.init(referencing: data as NSData)
        
    }
    mutating func appendMultipartItem(item: MultipartBodyItem, boundary: String) {
        
        appendStringLine(string: "--\(boundary)")
        
        appendStringLine(string: "Content-Type: \(item.mimeType.rawValue)")
        appendNewLine()
        appendStringLine(string: "Content-Length: \(item.data.count)")
        
        for header in item.headers {
            appendStringLine(string: "\(header.key): \(header.requestHeaderValue)")
        }
        debugPrint("Upload string before upload = \(String(data: self, encoding:.utf8))")
        append(item.data)
        appendNewLine()
    }
}

// MARK: - Data Helpers
extension Data {
    public mutating func appendString(string: String) {
        guard let data = string.data(using: .utf8) else { return }
        append(data)
    }
    public mutating func appendNewLine() {
        appendString(string: "\r\n")
    }
    public mutating func appendStringLine(string: String) {
        appendString(string: string)
        appendNewLine()
    }
}
