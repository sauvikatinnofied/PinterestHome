//
//  EncodingDecoding.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 26/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation

public protocol DataEncodable {
    func endodeToData() throws -> Data
}

public protocol DataDecodable {
    init?(data: Data) throws
}
