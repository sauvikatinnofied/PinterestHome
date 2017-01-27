//
//  WebImage.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation
import UIKit

struct WebImage: DataDecodable {
    
    var image: UIImage!
    init?(data: Data) throws {
        image = UIImage(data: data)
    }
}
