//
//  JSON.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 26/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]

public protocol JSONDecodable {
    init?(jsonDictionary: JSONDictionary?)
}

public protocol JSONConvertible: JSONDecodable, JSONEncodable {}

public protocol JSONArrayConvertible: JSONConvertible {
    //having nil is a workround for bug with extensions rdar://23314307
    //when it's fixed there should be extension of JSONArrayOf where T: JSONArrayConvertible
    //but it actually can make sence if array of objects is root objecti in json
    static var itemsKey: String? { get }
}

public protocol JSONEncodable {
    var jsonDictionary: JSONDictionary { get }
}

public protocol JSONContainer {
    associatedtype Element
    
    var value: Element {get set}
    
    init(_ value: Element)
    init?(_ value: Element?)
}

extension JSONContainer {
    public init?(_ value: Element?) {
        guard let value = value else { return nil }
        self.init(value)
    }
}

public struct JSONObject: JSONContainer {
    public var value: JSONDictionary
    
    public init(_ value: JSONDictionary) {
        self.value = value
    }
}

public struct JSONArray: JSONContainer {
    public var value: [JSONDictionary]
    
    public init(_ value: [JSONDictionary]) {
        self.value = value
    }
}

public struct JSONArrayOf<T: JSONArrayConvertible>: JSONContainer {
    public var value: [T]
    
    public init(_ value: [T]) {
        self.value = value
    }
}

extension Dictionary {
    mutating func append(_ element: (Key, Value)) -> [Key:Value] {
        self[element.0] = element.1
        return self
    }
}

func +<K: Hashable,V>(lhs: [K: V], rhs: (K, V)) -> [K: V] {
    var lhs = lhs
    return lhs.append(rhs)
}

//MARK: - Subscript
extension JSONObject: ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        self.init(elements.reduce([:]) { $0 + $1 })
    }
    
    public subscript(keyPaths: String...) -> AnyObject? {
        return keyPath(keyPaths.joined(separator: "."))
    }
    
    public func keyPath<T: JSONDecodable>(_ keyPath: String) -> [T]? {
        if let jsonDict: [JSONDictionary] = self.keyPath(keyPath) {
            return jsonDict.flatMap { T(jsonDictionary: $0) }
        }
        return nil
    }
    
    public func keyPath<T: JSONDecodable>(_ keyPath: String) -> T? {
        if let jsonDict: JSONDictionary = self.keyPath(keyPath) {
            return T(jsonDictionary: jsonDict)
        }
        return nil
    }
    
    public func keyPath<T>(_ keyPath: String) -> T? {
        guard let paths = partitionKeyPath(keyPath) else { return nil }
        return (paths.count == 1 ? value[keyPath] : resolve(paths)) as? T
    }
    
    fileprivate func partitionKeyPath(_ keyPath: String) -> [String]? {
        var paths = keyPath.components(separatedBy: ".")
        var key: String!
        var partitionedPaths = [String]()
        repeat {
            key = paths.removeFirst()
            if key.hasPrefix("@") && paths.count > 0 {
                key = "\(key).\(paths.removeFirst())"
            }
            partitionedPaths += [key]
        } while paths.count > 0
        return partitionedPaths
    }
    
    private func resolve(_ keyPaths: [String]) -> Any? {
        var keyPaths = keyPaths
        var result = value[keyPaths.removeFirst()]
        while keyPaths.count > 1 && result != nil {
            let key = keyPaths.removeFirst()
            result = resolve(key, value: result!)
        }
        if let result = result {
            return resolve(keyPaths.last!, value: result)
        }
        return nil
    }
    
    fileprivate func resolve(_ key: String, value: Any) -> Any? {
        if key.hasPrefix("@"), let array = value as? Array<Any>  {
            return resolve(key, array: array as Array<Any>)
        } else if value is JSONDictionary{
            return (value as! JSONDictionary)[key]
        }
        return nil
    }
    
    fileprivate func resolve(_ key: String, array: Array<Any>) -> Any? {
        let startIndex = key.characters.index(key.startIndex, offsetBy: 1)
        let substring = key.substring(from: startIndex)
        return CollectionOperation(substring).collect(array)
    }
    
    enum CollectionOperation {
        case index(Int)
        case first
        case last
        case keyPath(String)
        
        init(_ rawValue: String) {
            switch rawValue {
            case _ where Int(rawValue) != nil:
                self = .index(Int(rawValue)!)
            case "first":
                self = .first
            case "last":
                self = .last
            default:
                self = .keyPath(rawValue)
            }
        }
        
        func collect(_ array: Array<Any>) -> Any? {
            switch self {
            case .index(let index):
                return array[index]
            case .first:
                return array.first
            case .last:
                return array.last
            case .keyPath(let keyPath):
                return (array as NSArray).value(forKeyPath: "@\(keyPath)") as AnyObject?
            }
        }
    }
    
}

//MARK: - Data

extension Data {
    
    public func decodeToJSON() throws -> JSONDictionary? {
        return try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions()) as? JSONDictionary
    }
    
    public func decodeToJSON() throws -> Any? {
        return try JSONSerialization.jsonObject(with: self, options: [.allowFragments])
    }
    
    public func decodeToJSON() throws -> [JSONDictionary]? {
        return try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions()) as? [JSONDictionary]
    }
    
    public func decodeToJSON<J: JSONDecodable>() throws -> J? {
        return try J(jsonDictionary: self.decodeToJSON())
    }
    
    public func decodeToJSON<J: JSONDecodable>() throws -> [J]? {
        let array: [JSONDictionary]? = try self.decodeToJSON()
        return array?.flatMap { J(jsonDictionary: $0) }
    }
    
}

extension JSONEncodable {
    public func encodeJSON() throws -> Data {
        return try serializeJSON(self.jsonDictionary as AnyObject)
    }
}

public func encodeJSONDictionary(_ jsonDictionary: JSONDictionary) throws -> Data {
    return try serializeJSON(jsonDictionary as AnyObject)
}

public func encodeJSONArray(_ jsonArray: [JSONDictionary]) throws -> Data {
    return try serializeJSON(jsonArray as AnyObject)
}

public func encodeJSONObjectsArray(_ objects: [JSONEncodable]) throws -> Data {
    return try serializeJSON(objects.map { $0.jsonDictionary })
}

private func serializeJSON(_ obj: Any) throws -> Data {
    return try JSONSerialization.data(withJSONObject: obj, options: JSONSerialization.WritingOptions())
}

extension Optional {
    public var String: Swift.String? {
        return self as? Swift.String
    }
    
    public var Double: Swift.Double? {
        return self as? Swift.Double
    }
    
    public var Int: Swift.Int? {
        return self as? Swift.Int
    }
    
    public var Bool: Swift.Bool? {
        return self as? Swift.Bool
    }
    
    public var Array: [JSONDictionary]? {
        return self as? [JSONDictionary]
    }
    
    public var Object: JSONDictionary? {
        return self as? JSONDictionary
    }
}
