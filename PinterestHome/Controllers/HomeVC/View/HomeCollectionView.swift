//
//  HomeCollectionView.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import UIKit

class HomeCollectionView: UICollectionView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        config()
    }

    
    // MARK: PRIVATE HELPERS
    func config() {
        showsVerticalScrollIndicator = false // Hiding vertical scroll indicator
    }
    
}


extension UICollectionView {
    func dequeCell<T: UICollectionViewCell>(cellClass: T.Type, at indexPath: IndexPath) -> T {
        let reusableID = (cellClass as UICollectionViewCell.Type).indentifire
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: reusableID, for: indexPath) as? T else {
            fatalError("Please check your cell's ID is same as it's class name")
        }
        return cell
    }
    
    func dequeResulableView<T: UICollectionReusableView>(kind: String, viewClass: T.Type, at indexPath: IndexPath) -> T {
        let reusableID = (viewClass as UICollectionReusableView.Type).indentifire
        
        guard let view = dequeueReusableSupplementaryView(ofKind: kind,
                                                          withReuseIdentifier: reusableID, for: indexPath) as? T else {
            fatalError("Please check your cell's ID is same as it's class name")
        }
        return view
    }
}


