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
            return "sauvikatinnofied/4339fb17e5c988a1b77ec02346f6cf56/raw/fb332000ae1534145e12590532eee9abac1c9876/PinterestHome.json"
        }
        
    }
    var method: HTTPMethod {
        switch self {
        case .allPosts:
            return .get
        }
    }
}
