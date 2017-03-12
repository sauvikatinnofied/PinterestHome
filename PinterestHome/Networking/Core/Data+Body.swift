//
//  Data+Body.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 11/03/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation


// MARK: JSON Body
public struct HTTPJSONBody {
    let dictionary: JSONDictionary
    public init(dictionary: JSONDictionary){
        self.dictionary = dictionary
    }
}

extension HTTPJSONBody: DataEncodable {
    public func endodeToData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.dictionary,
                                          options: .prettyPrinted)
    }
}


// MARK: MULTI-PART Body
public struct HTTPMultipartBody {
    let paramDictionary: JSONDictionary?
    let attachments: [MultipartBodyItem]
    let boundary: String
    
    init(parameters: JSONDictionary?, attachments: [MultipartBodyItem],
         boundary: String = UUID().uuidString) {
        self.paramDictionary = parameters
        self.attachments = attachments
        self.boundary = boundary
    }
}

extension HTTPMultipartBody: DataEncodable {
    public func endodeToData() throws -> Data {
        
        var body = Data(multipartItems: self.attachments, boundary: self.boundary)
        
        if let paramDictionary = self.paramDictionary,
            let data = try Data(parameters:paramDictionary, boundary: boundary) {
            body.append(data)
        }
        return body
    }
}

