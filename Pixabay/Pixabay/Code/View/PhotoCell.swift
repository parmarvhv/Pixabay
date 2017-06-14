//
//  PhotoCell.swift
//  Pixabay
//
//  Created by Nickelfox on 02/03/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
   
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellImageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCorner()
    }
    override func prepareForReuse() {
        cellImageView.image = nil
    }
    func imageCorner() {
        cellImageView.layer.masksToBounds = true
        cellImageView.layer.cornerRadius = 3
    }
    func populateCell(imageUrl: String?) {
        if let imageUrl = imageUrl {
            self.cellImageView.downloadImage(from: imageUrl)
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PintrestAttributes {
            cellImageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
