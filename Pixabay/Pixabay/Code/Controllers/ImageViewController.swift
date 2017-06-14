//
//  ImageViewController.swift
//  Pixabay
//
//  Created by Vaibhav Parmar on 25/04/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet var thumbnailView: UIImageView!
    
    var imageUrl: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
    }
    
    func setupUIElements() {
        thumbnailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissView)))
        //thumbnailView.layer.cornerRadius = thumbnailView.frame.size.width/2.0
        thumbnailView.clipsToBounds = true
        thumbnailView.isUserInteractionEnabled = true
        self.thumbnailView.downloadImage(from: imageUrl)
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
