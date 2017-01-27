//
//  HTTPClient.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 26/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation

public class HTTPClient {
    
    public let baseURL: URL
    private let session: URLSession
    
    let requestGenerator: HTTPRequestGenerator
    let responseGenerator: HTTPResponseGenerator
    
    public init(baseURL: URL, session: URLSession,
                requestProcessing: HTTPRequestGenerator = HTTPDefaultRequestGenerator(),
                responseProcessing: HTTPResponseGenerator = HTTPDefaultResponseGenerator()) {
        self.baseURL = baseURL
        self.session = session
        self.requestGenerator = requestProcessing
        self.responseGenerator = responseProcessing
    }
    
    
    // REST API
    public func request<ResultType>(request: HTTPRequestFor<ResultType>,
                        completion: @escaping (HTTPResponseOf<ResultType>) -> Void) -> URLSessionTask? {
        var task: URLSessionTask?
        do {
            let httpRequest = try self.requestGenerator.generateRESTRequest(request: request)
            task = self.session.dataTask(with: httpRequest,
                                         completionHandler: { (data, response, error) -> Void in
                                            
                                            
               self.completeRequest(typedRequest: request, request: httpRequest,
                                     data: data, response: response!,
                                     error: error, completionHandler: completion)
            })
            task?.resume()
        }
        catch {
            cancelRequestWithError(error: error, completionHandler: completion)
        }
        return task
    }
    
    
    // File Download
    public func download<ResultType>(request: HTTPFileRequestFor<ResultType>,
                         completion: @escaping (HTTPResponseOf<ResultType>) -> Void) -> URLSessionTask? {
        
        var task: URLSessionTask?
        do {
            let downloadRequest = try self.requestGenerator.generateFileDownloadRequest(request: request)
            
            task = self.session.dataTask(with: downloadRequest, completionHandler: { (data, response, error) in
                self.completeFileLoadRequest(typedRequest: request, request: downloadRequest,
                                     data: data, response: response,
                                     error: error, completionHandler: completion)
            })
            task?.resume()
        }
        catch {
            cancelRequestWithError(error: error, completionHandler: completion)
        }
        return task
        
    }
    
    
    // MARK: REST Call Handling
    private func completeRequest<ResultType>(typedRequest: HTTPRequestFor<ResultType>, request: URLRequest, data: Data!,
                                 response: URLResponse, error: Error!,
                                 completionHandler: @escaping (HTTPResponseOf<ResultType>) -> Void) {
        
        var apiResponse = HTTPResponseOf<ResultType>(request: request, data: data, httpResponse: response, error: error)
        apiResponse = self.responseGenerator.generateResponse(response: &apiResponse, request: typedRequest)
        DispatchQueue.main.async {
             completionHandler(apiResponse)
        }
    }
    
    private func cancelRequestWithError<ResultType>(error: Error?,
                                        completionHandler: @escaping (HTTPResponseOf<ResultType>) -> Void) {
        
        let response = HTTPResponseOf<ResultType>(request: nil, data: nil,
                                                  httpResponse: nil, error: error)
        
        DispatchQueue.main.async {
            completionHandler(response)
        }
    }
    
    // MARK: FILE LOAD HANDLING
    private func completeFileLoadRequest<ResultType>(typedRequest: HTTPFileRequestFor<ResultType>, request: URLRequest, data: Data!,
                                         response: URLResponse!, error: Error!,
                                         completionHandler: @escaping (HTTPResponseOf<ResultType>) -> Void) {
        
        var apiResponse = HTTPResponseOf<ResultType>(request: request, data: data, httpResponse: response, error: error)
        apiResponse = self.responseGenerator.generateResponse(response: &apiResponse, request: typedRequest)
        DispatchQueue.main.async {
            completionHandler(apiResponse)
        }
        
    }
}
