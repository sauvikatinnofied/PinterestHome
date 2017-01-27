//
//  ImageProcessing.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation
import UIKit

let imageProcessingQueue = DispatchQueue(label: "com.PinterestHome", qos: .userInitiated, attributes: .concurrent)

extension UIImage {
    func resize(newWidth: Double, completion: @escaping (UIImage?) -> Void) {
        imageProcessingQueue.async { [weak self] in
            
            guard let strongSelf = self else {
                completion(nil)
                return
            }
            
            
            let scale = CGFloat(newWidth) / strongSelf.size.width
            let newHeight = strongSelf.size.height * scale
            let newSize = CGSize(width: CGFloat(newWidth), height: newHeight)
            UIGraphicsBeginImageContext(newSize)
            strongSelf.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completion(newImage)
        }
    }
}
