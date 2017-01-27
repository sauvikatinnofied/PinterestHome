//
//  HTTPResponse.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 26/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation

public protocol HTTPResponse {
    
    var httpResponse: HTTPURLResponse? {get}
    var data: Data? {get}
    var error: Error? {get}
    var originalRequest: URLRequest? {get}
    var contentType: HTTPContentType? {get}
}

public struct HTTPResponseOf<ResultType: DataDecodable>: HTTPResponse {
    
    public let httpResponse: HTTPURLResponse?
    public let data: Data?
    public let originalRequest: URLRequest?
    internal(set) public var error: Error?
    internal(set) public var result: ResultType?
    public var contentType: HTTPContentType? {
        get {
            return httpResponse?.mimeType.flatMap {HTTPContentType(rawValue: $0)}
        }
    }
    
    init(request: URLRequest? = nil, data: Data? = nil, httpResponse: URLResponse? = nil, error: Error? = nil) {
        self.originalRequest = request
        self.httpResponse = httpResponse as? HTTPURLResponse
        self.data = data
        self.error = error
        self.result = nil
    }
    
    public func map<T>(_ f: (ResultType) -> T) -> HTTPResponseOf<T> {
        return flatMap(f)
    }
    
    public func mapError<E: Error>(_ f: (Error) -> E) -> HTTPResponseOf {
        return flatMapError(f)
    }
    
    public func flatMap<T>(_ f: (ResultType) -> T?) -> HTTPResponseOf<T> {
        var response = HTTPResponseOf<T>(request: originalRequest, data: data, httpResponse: httpResponse, error: error)
        response.result = result.flatMap(f)
        return response
    }
    
    public func flatMapError<E: Error>(_ f: (Error) -> E?) -> HTTPResponseOf {
        var response = HTTPResponseOf(request: originalRequest, data: data, httpResponse: httpResponse, error: error.flatMap(f) ?? error)
        response.result = result
        return response
    }
    
}


public protocol HTTPFileResponse: HTTPResponse {
    
}
public struct HTTPFileResponseOf<ResultType: DataDecodable>: HTTPFileResponse {
    public var contentType: HTTPContentType?
    public let httpResponse: HTTPURLResponse?
    public let data: Data?
    public let originalRequest: URLRequest?
    internal(set) public var error: Error?
    internal(set) public var result: ResultType?
    
}
public struct None: DataDecodable {
    public init?(data: Data) throws {
        return nil
    }
}

