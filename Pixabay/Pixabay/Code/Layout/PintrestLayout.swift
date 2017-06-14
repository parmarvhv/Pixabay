//
//  PintrestLayout.swift
//  Pinterest
//
//  Created by Nickelfox on 02/03/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
// MARK: PintrestLayoutDelegate
protocol PintrestLayoutDelegate {
  func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

//MARK: class PintrestLayoutAttributes
class PintrestAttributes: UICollectionViewLayoutAttributes {
    
  var photoHeight: CGFloat = 0.0
  override func copy(with zone: NSZone?) -> Any {
    let copy = super.copy(with: zone) as! PintrestAttributes
    copy.photoHeight = photoHeight
    return copy
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    if let attributes = object as? PintrestAttributes {
      if(attributes.photoHeight == photoHeight) {
        return super.isEqual(object)
      }
    }
    return false
  }
}


// MARK: class PintrestLayout
class PintrestLayout: UICollectionViewLayout {
    
  var delegate: PintrestLayoutDelegate!
    var numberOfColumns: Int = 2
  var cellPadding: CGFloat = 6.0
  private var cache = [PintrestAttributes]()
  
  private var contentHeight: CGFloat = 0.0
  private var contentWidth: CGFloat {
    let insets = collectionView!.contentInset
    return collectionView!.bounds.width - (insets.left + insets.right)
  }
  
  override func prepare() {
    if cache.isEmpty{
      let columnWidth = contentWidth / CGFloat(numberOfColumns)
      var xOffset = [CGFloat]()
      for column in 0..<numberOfColumns {
        xOffset.append(CGFloat(column)*columnWidth)
      }
      var column = 0
      var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
      for item in 0..<collectionView!.numberOfItems(inSection: 0) {
        let indexPath = IndexPath(item: item, section: 0)
        let width = columnWidth - cellPadding * 2
        let photoHeight = delegate.collectionView(collectionView: collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
        let height = cellPadding + photoHeight + cellPadding
        let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        let attributes = PintrestAttributes(forCellWith: indexPath as IndexPath)
        attributes.photoHeight = photoHeight
        attributes.frame = insetFrame
        cache.append(attributes)
        contentHeight = max(contentHeight, frame.maxY)
        yOffset[column] = yOffset[column] + height
        column = column >= (numberOfColumns - 1) ? 0 : (column + 1)
      }
    }
  }
    
    func reset() {
        self.cache.removeAll()
        self.invalidateLayout()
    }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
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
  
  override class var layoutAttributesClass: AnyClass {
    return PintrestAttributes.self
  }
  
  
}
