//
//  PinCell.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import UIKit

class PinCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func setUp() {
        // Adding corner radius
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(Constants.Pinterest.PostCornerRadius)

    }
    override func didAddSubview(_ subview: UIView) {
        if subview is UIImageView {
            imageView.alpha = 0.0 // Initial Invisible
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            DispatchQueue.main.async { [weak self] in
                guard let strongself = self else { return }
                strongself.imageViewHeightLayoutConstraint.constant = attributes.photoHeight
            }
        }
    }
    
    func loadImage(post: PinterestPost) {
        self.imageView.setImageURL(imageURL: post.urls.regular, placeHolder: nil)
    }
}


extension UICollectionViewCell {
    override class var indentifire: String {
        return "\(self)"
    }
    static func instantiateAsReusable(inCollectionView collectionView: UICollectionView,
                                      at indexPath: IndexPath) -> Self {
        return collectionView.dequeCell(cellClass: self, at: indexPath)
    }
}

extension UIImageView {
    
    func setImageURL(imageURL: String, placeHolder: String?) {
        
        if let placeHolder = placeHolder, let image = UIImage(named: placeHolder ) {
            self.image =  image
        }
        
        let imageRequest =  HTTPFileRequestFor<WebImage>(fullPath: imageURL)
        
        let _ = HTTPCacheClient.shared.request(request: imageRequest, completion: { [weak self] (response) in
            
            guard let strongSelf = self,
            let webImage = response.result?.image else { return }
            DispatchQueue.main.async {
                // Adding image with Fade In Animation
                UIView.transition(with: strongSelf,
                                  duration: Constants.Animation.FadeInDuration,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    strongSelf.image = webImage
                },
                completion: nil)
            }
        })
    }
}



