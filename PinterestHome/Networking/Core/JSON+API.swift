//
//  JSON+API.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation

extension JSONObject: DataDecodable, DataEncodable {
    
    public init?(data: Data) throws {
        self.init(try data.decodeToJSON())
    }
    
    public func endodeToData() throws -> Data {
         return try encodeJSONDictionary(value)
    }
    
}

extension JSONArray: DataDecodable, DataEncodable {
    
    public init?(data: Data) throws {
        self.init(try data.decodeToJSON())
    }
    
    public func endodeToData() throws -> Data {
        return try encodeJSONArray(value)
    }
}

extension JSONArrayOf: DataDecodable, DataEncodable {
    
    public init?(data: Data) throws {
        let jsonArray: [JSONDictionary]
        if let jsonArrayRootKey = T.itemsKey {
            guard let jsonDictionary: JSONDictionary = try data.decodeToJSON(),
                let _jsonArray = jsonDictionary[jsonArrayRootKey] as? [JSONDictionary] else {
                    return nil
            }
            jsonArray = _jsonArray
        }
        else {
            guard let _jsonArray: [JSONDictionary] = try data.decodeToJSON() else {
                return nil
            }
            jsonArray = _jsonArray
        }
        self = JSONArrayOf<T>(jsonArray.flatMap { T(jsonDictionary: $0) })
    }
    
   public func endodeToData() throws -> Data {
        if let jsonArrayRootKey = T.itemsKey {
            return try encodeJSONDictionary([jsonArrayRootKey: value.map({$0.jsonDictionary})])
        }
        else {
            return try encodeJSONArray(value.map({$0.jsonDictionary}))
        }
    }
    
}

public protocol JSONValue: DataDecodable {}

extension JSONValue {
    
    public init?(data: Data) throws {
        guard let result: JSONDictionary = try data.decodeToJSON() else {
            return nil
        }
        if let result = result as? Self {
            self = result
        } else {
            return nil
        }
    }
}

//extension String: JSONValue {}
//extension IntegerLiteralType: JSONValue {}
//extension FloatLiteralType: JSONValue {}
//extension BooleanLiteralType: JSONValue {}
extension JSONArray: JSONValue {}
extension JSONObject: JSONValue {}


public let JSONHeaders = [HTTPHeader.contentType(HTTPContentType.json), HTTPHeader.accept([HTTPContentType.json])]

