//
//  PinterestCollectionLoadMoreCell.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 28/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import UIKit

class PinterestCollectionLoadMoreCell: UICollectionReusableView {
        
}

extension UICollectionReusableView {
    class var indentifire: String {
        return "\(self)"
    }
    static func dequeue(kind: String, inCollectionView collectionView: UICollectionView,
                                      at indexPath: IndexPath) -> Self {
        return collectionView.dequeResulableView(kind: kind, viewClass: self, at: indexPath)
    }
}
