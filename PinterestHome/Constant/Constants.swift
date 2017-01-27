//
//  Constants.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation
import UIKit


struct Constants { }


extension Constants {
    struct Cache {
        static let MaxSizeInKB = 20 * 1024
    }
}

extension Constants {
    struct Animation {
        static let FadeInDuration = 0.3
    }
}

extension Constants {
    struct Pinterest {
        static let PostCornerRadius = 5.0
    }
}


enum Color {
    case tintColor
    
    var innstace: UIColor {
        switch self {
        case .tintColor:
            return UIColor(hexString: "#CC0133")
        }
    }
}
