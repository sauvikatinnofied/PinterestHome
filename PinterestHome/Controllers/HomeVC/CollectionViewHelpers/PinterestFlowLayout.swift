//
//  PinFlowLayout.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import UIKit


protocol PinterestLayoutDelegate: class {
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:NSIndexPath,
                        withWidth:CGFloat) -> CGFloat
    
}


class PinterestFlowLayout: UICollectionViewLayout {

    weak var delegate: PinterestLayoutDelegate!
    
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    private var cache = [PinterestLayoutAttributes]()
    
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    override class var layoutAttributesClass: AnyClass {
        return PinterestLayoutAttributes.self
    }
    
    override func prepare() {

        if cache.isEmpty {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = NSIndexPath(item: item, section: 0)
                
                let width = columnWidth - cellPadding * 2
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath,
                                                          withWidth:width)
                let height = cellPadding +  photoHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                

                let attributes = PinterestLayoutAttributes(forCellWith: indexPath as IndexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    
    

}

