//
//  Serialization.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation




public protocol HTTPRequest {
    
    var body: Data? {get}
    var endpoint: Endpoint {get}
    var baseURL: URL {get}
    var headers: [HTTPHeader] {get}
    var query: [String: String] {get}
    
}



public struct HTTPRequestFor<ResultType: DataDecodable>: HTTPRequest {
    
    public let body: Data?
    public let endpoint: Endpoint
    public let baseURL: URL
    public let headers: [HTTPHeader]
    public let query: [String: String]
    
    public init(endpoint: Endpoint, baseURL: URL, query: [String: String] = [:], headers: [HTTPHeader] = []) {
        self.endpoint = endpoint
        self.baseURL = baseURL
        self.query = query
        self.headers = headers
        self.body = nil
    }
    
    public init(endpoint: Endpoint, baseURL: URL, input: DataEncodable, query: [String: String] = [:], headers: [HTTPHeader] = []) throws {
        self.endpoint = endpoint
        self.baseURL = baseURL
        self.query = query
        self.headers = headers
        self.body = try input.endodeToData()
    }
    
}


public protocol HTTPFileRequest {
    var fullPath: String { get }
    var headers: [HTTPHeader] {get}
}

public struct HTTPFileRequestFor<ResultType: DataDecodable>: HTTPFileRequest {
    
    public let  fullPath: String
    public let  headers: [HTTPHeader]
    init(fullPath: String, headers: [HTTPHeader] = []) {
        self.fullPath = fullPath
        self.headers = headers
    }
}

