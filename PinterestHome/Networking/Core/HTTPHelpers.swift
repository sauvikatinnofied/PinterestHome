//
//  APIHelpers.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 25/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation


public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}
public protocol Endpoint {
    var     path: String {get}
    var   method: HTTPMethod {get}
}

//public typealias MIMEType = String
public enum MIMEType: String {
    case imageJPEG  = "image/jpeg"
    case imagePNG   = "image/png"
    case pdf        = "application/pdf"
    case json       = "application/json"
}

public enum HTTPHeader {
    
    case contentDisposition(formKey: String)
    case contentDispositionMIMEType(fileKey: String, fileName:String)
    case accept([HTTPContentType])
    case contentType(HTTPContentType)
    case authorization(String)
    case custom(String, String)
    
    var key: String {
        switch self {
        case .contentDisposition, .contentDispositionMIMEType:
            return "Content-Disposition"
        case .accept:
            return "Accept"
        case .contentType:
            return "Content-Type"
        case .authorization:
            return "Authorization"
        case .custom(let key, _):
            return key
        }
    }
    
    var requestHeaderValue: String {
        switch self {
        case .contentDisposition(let disposition):
            return "form-data; name=\"\(disposition)\""
        case .contentDispositionMIMEType(let fileKey, let fileName):
            return "form-data; name=\"\(fileKey)\"; filename=\"\(fileName)\""
        case .accept(let types):
            let typeStrings = types.map({$0.rawValue})
            return typeStrings.joined(separator: ", ")
        case .contentType(let type):
            return type.rawValue
        case .authorization(let token):
            return token
        case .custom(_, let value):
            return value
        }
    }
    
    func setRequestHeader(request: inout URLRequest) {
        request.setValue(requestHeaderValue, forHTTPHeaderField: key)
    }
}

public enum HTTPContentType: RawRepresentable {
    
    case json
    case form
    case multipart(String)
    
    public typealias RawValue = MIMEType.RawValue
    
    public init?(rawValue: HTTPContentType.RawValue) {
        switch rawValue {
        case "application/json": self = .json
        default: return nil
        }
    }
    
    public var rawValue: HTTPContentType.RawValue {
        switch self {
        case .json: return "application/json"
        case .form: return "application/x-www-form-urlencoded"
        case .multipart(let boundary): return "multipart/form-data; boundary=\(boundary)"
        }
    }
}
