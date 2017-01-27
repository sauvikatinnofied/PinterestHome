//
//  HTTPErrors.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 26/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation



public enum HTTPErrorCode: Int {
    case unknownError
    case invalidCredentials
    case invalidUserName
    case invalidPassword
    case unauthorized
    case serializationError
    case httpError
    case backendError
    case invalidResponse
    case badRequest
}

enum HTTPError: Error {
    case custom(HTTPErrorCode, [AnyHashable: Any]?)
    case underLying(Int, Error?)
}
extension HTTPError {
    
    public static func errorWithUnderlyingError(_ error: Error?, code: Int) -> HTTPError {
        return HTTPError.underLying(code, error)
    }
    public static func errorWithCode(_ code: HTTPErrorCode) -> HTTPError {
        return HTTPError.underLying(code.rawValue, nil)
    }
    
    static func backendError(_ statusCode: Int, data: Data?) -> HTTPError? {
        switch statusCode {
        case 200..<300: return nil
        case 401:
            return HTTPError.custom(.unauthorized, backendErrorUserInfo(statusCode, data: data))
        default:
            return HTTPError.custom(.backendError, backendErrorUserInfo(statusCode, data: data))
        }
    }

    
    static func backendErrorUserInfo(_ statusCode: Int, data: Data?) -> [AnyHashable: Any]? {
        var userInfo: [AnyHashable: Any] = ["statusCode": statusCode]
        if let data = data {
            do {
                userInfo["response"] = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            }
            catch {
                userInfo["response"] = String(data: data, encoding: .utf8)
            }
        }
        return userInfo
    }
}
