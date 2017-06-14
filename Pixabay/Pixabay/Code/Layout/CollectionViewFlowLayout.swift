//
//  CarouselCollectionViewFlowLayour.swift.swift
//  newsApp
//
//  Created by Nickelfox on 01/03/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    fileprivate var currentVisiblePage = 0
    fileprivate var currentOffset = CGPoint.zero
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y)
        }
        let collectionViewBounds = collectionView.bounds
        let halfWidth = collectionViewBounds.size.width / 2;
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth;
        
        if let attributesForVisibleCells = layoutAttributesForElements(in: collectionViewBounds) {
            var candidateAttributes : UICollectionViewLayoutAttributes?
            for attributes in attributesForVisibleCells {
                if let cAttributes = candidateAttributes {
                    let a = attributes.center.x - proposedContentOffsetCenterX
                    let b = cAttributes.center.x - proposedContentOffsetCenterX
                    if fabsf(Float(a)) < fabsf(Float(b)) {
                        candidateAttributes = attributes;
                    }
                }
                else { // == First time in the loop == //
                    candidateAttributes = attributes;
                    continue;
                }
            }
            return CGPoint(x: round(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
        }
        // Fallback
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let array = super.layoutAttributesForElements(in: rect) {
            for attributes in array {
                let frame = attributes.frame
                let distance = abs(collectionView!.contentOffset.x - frame.origin.x + sectionInset.left)
                let scale = 1 * min(max(1 - distance / (6 * collectionView!.bounds.width), 0.9), 1)
                attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            return array
        }
        return nil
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
