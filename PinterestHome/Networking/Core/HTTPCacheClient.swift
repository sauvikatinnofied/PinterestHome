//
//  CachedHTTPClient.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation

final class HTTPCacheClient {
    
    var httpClient: HTTPClient
    var onMemoryCache: MemoryCache
    
    static var shared: HTTPCacheClient!
    
    public init(httpClient: HTTPClient, cache: MemoryCache) {
        self.httpClient = httpClient
        self.onMemoryCache = cache
        HTTPCacheClient.shared = self
    }
    
    public func request<ResultType>(request: HTTPRequestFor<ResultType>,
                        completion: @escaping (HTTPResponseOf<ResultType>) -> Void) -> URLSessionTask? {
        
        
        let isRespoonseToBeCached = isRequestTobeCached(request: request)
        
        guard let urlRequest = try? self.httpClient.requestGenerator.generateRESTRequest(request: request) else {
            return nil
        }
        
        if let dataInCache = self.onMemoryCache[urlRequest.url!.absoluteString] {
            
            // Generate the HTTPResponse
            let response = HTTPResponseOf<ResultType>(request: nil, data: dataInCache.data, httpResponse: nil, error: nil)
            completion(response)
            return nil
        } else {
            return self.httpClient.request(request: request) { [weak self] (response)  in //
                
                // Caching goes here
                if isRespoonseToBeCached {
                    self?.onMemoryCache[urlRequest.url!.absoluteString] = CacheItem(httpResponse: response)
                }
                
                // Calling the completion
                completion(response)
            }
        }

    }
    
    public func request<ResultType>(request: HTTPFileRequestFor<ResultType>,
                        completion: @escaping (HTTPResponseOf<ResultType>) -> Void) -> URLSessionTask? {
        
        
        // TODO: Caching only for GET Request
        
        if let dataInCache = self.onMemoryCache[request.fullPath] {
            
            // Generate the HTTPResponse
            var response = HTTPResponseOf<ResultType>(request: nil, data: dataInCache.data, httpResponse: nil, error: nil)
            response = self.httpClient.responseGenerator.generateResponse(response: &response, request: request)
            completion(response)
            return nil
        } else {
            return self.httpClient.download(request: request, completion: { [weak self] (response) in
                // Each file type will be cached
                self?.onMemoryCache[request.fullPath] = CacheItem(httpResponse: response)
                // Calling the completion
                completion(response)
            })

            }
    }
    
    // MARK: PRIVATE HELPERS
    private func isRequestTobeCached<T>(request: HTTPRequestFor<T>) -> Bool{
        return request.endpoint.method == .get // only get requests are to be cached
    }
}
