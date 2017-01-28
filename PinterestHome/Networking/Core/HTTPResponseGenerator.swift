//
//  HTTPResponseGenerator.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation


public protocol HTTPResponseGenerator {
    func generateResponse<ResultType>(response: inout HTTPResponseOf<ResultType>,
                         request: HTTPRequestFor<ResultType>) -> HTTPResponseOf<ResultType>
    func generateResponse<ResultType>(response: inout HTTPResponseOf<ResultType>,
                                 request: HTTPFileRequestFor<ResultType>) -> HTTPResponseOf<ResultType>
    
}


public class HTTPDefaultResponseGenerator: HTTPResponseGenerator {
    
    public func generateResponse<ResultType>(response: inout HTTPResponseOf<ResultType>,
                                request: HTTPRequestFor<ResultType>) -> HTTPResponseOf<ResultType> {
        do {
            try validate(response: response, request: request)
            response.result = try decode(response: response, request: request)
        }
        catch {
            response.error = error
        }
        return response
    }
    public func generateResponse<ResultType>(response: inout HTTPResponseOf<ResultType>,
                                 request: HTTPFileRequestFor<ResultType>) -> HTTPResponseOf<ResultType> {
        do {
            response.result = try decode(response: response, request: request)
        }
        catch {
            response.error = error
        }
        return response
    }


    
    final private func validate<ResultType>(response: HTTPResponseOf<ResultType>, request: HTTPRequestFor<ResultType>) throws {
        try validateError(response: response, request: request)
        try validateHTTPResponse(response: response, request: request)
        try validateStatusCode(response: response, request: request)
        try validateContentType(response, request: request)
    }
    
    final private func validateError<ResultType>(response: HTTPResponseOf<ResultType>, request: HTTPRequestFor<ResultType>) throws {
        if let error = response.error {
            throw error
        }
    }
    
    final private func validateHTTPResponse<ResultType>(response: HTTPResponseOf<ResultType>, request: HTTPRequestFor<ResultType>) throws {
        if response.httpResponse == nil {
            throw HTTPError.errorWithCode(.backendError)
        }
    }
    
    final private func validateStatusCode<ResultType>(response: HTTPResponseOf<ResultType>, request: HTTPRequestFor<ResultType>) throws {
        
        if let error = HTTPError.backendError(response.httpResponse!.statusCode, data: response.data) {
            throw error
        }
    }
    
    final fileprivate func validateContentType<ResultType>(_ response: HTTPResponseOf<ResultType>, request: HTTPRequestFor<ResultType>) throws {
        if let contentType = response.contentType {
            for case let .accept(acceptable) in request.headers {
                if !acceptable.contains(where: { $0 == contentType }) {
                    throw HTTPError.errorWithCode(.invalidResponse)
                }
            }
        }
    }
    
    final private func decode<ResultType>(response: HTTPResponseOf<ResultType>, request: HTTPRequestFor<ResultType>) throws -> ResultType? {
        if let data = response.data {
            return try ResultType(data: data)
        }
        return nil
    }
    final private func decode<ResultType>(response: HTTPResponseOf<ResultType>, request: HTTPFileRequestFor<ResultType>) throws -> ResultType? {
        if let data = response.data {
            return try ResultType(data: data)
        }
        return nil
    }
    
    
    public init() {}
    
}



