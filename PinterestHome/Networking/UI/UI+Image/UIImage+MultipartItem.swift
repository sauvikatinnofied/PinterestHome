//
//  UIImage+MultipartItem.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 12/03/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import UIKit



public extension UIImage {
    
    func multipartBodyItemWith(itemType: MIMEType, quality: Double = 1.0, formKey: String, fileName: String) -> MultipartBodyItem {
        
        // Image compression qualaity check
        assert(quality > 0.0 && quality <= 1.0,
               "Image compression quality must be in between 0 and 1.0")
        assert(itemType == MIMEType.imageJPEG ||
                itemType == MIMEType.imagePNG,
               "Multipart item type does not match")

        var data: Data!
        
        switch itemType {
        case .imageJPEG:
            data = UIImageJPEGRepresentation(self, CGFloat(quality))
        case .imagePNG:
            data = UIImagePNGRepresentation(self)
        default:
            break // Invalid type of mine type
        }
        let headers = [HTTPHeader.contentDispositionMIMEType(fileKey: formKey,
                                                             fileName: fileName)]
        return MultipartBodyItem(data: data, mimeType: itemType,
                                              headers: headers)
    }
}
