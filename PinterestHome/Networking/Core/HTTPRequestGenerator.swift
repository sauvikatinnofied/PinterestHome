//
//  HttpRequestGenerator.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 26/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation


public protocol HTTPRequestGenerator {
    func generateRESTRequest(request: HTTPRequest) throws -> URLRequest
    func generateFileDownloadRequest(request: HTTPFileRequest) throws -> URLRequest
}


public class HTTPDefaultRequestGenerator: HTTPRequestGenerator {
    
    public var defaultHeaders: [HTTPHeader]
    public init(defaultHeaders: [HTTPHeader] = []) {
        self.defaultHeaders = defaultHeaders
    }
    

    public func generateRESTRequest(request: HTTPRequest) throws -> URLRequest {
        var components = URLComponents(string: request.endpoint.path)!
        components.queryItems = request.query.map {
            URLQueryItem(name: $0, value: $1)
        }
        guard let url = components.url(relativeTo: request.baseURL) else {
            throw HTTPError.errorWithCode(.badRequest)
        }
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = request.endpoint.method.rawValue
        httpRequest.httpBody = request.body
        for header in defaultHeaders + request.headers {
            header.setRequestHeader(request: &httpRequest)
        }
        return httpRequest as URLRequest
    }
    
    public func generateFileDownloadRequest(request: HTTPFileRequest) throws -> URLRequest {
        
        guard let url = URL(string: request.fullPath) else {
            throw HTTPError.errorWithCode(.badRequest)
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = HTTPMethod.get.rawValue
        for header in defaultHeaders + request.headers {
            header.setRequestHeader(request: &httpRequest)
        }        
        return httpRequest
    }
    
}
