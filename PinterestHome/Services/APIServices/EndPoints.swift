//
//  EndPoints.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation

enum PicturePostEndPoint: Endpoint {
    
    case allPosts
    
    var path: String {
        switch self {
        case .allPosts:
            return "raw/wgkJgazE"
        }
        
    }
    var method: HTTPMethod {
        switch self {
        case .allPosts:
            return .get
        }
    }
}
