//
//  UIImage.swift
//  Pixabay
//
//  Created by Nickelfox on 02/03/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    var decompressedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(at: CGPoint.zero)
        let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return decompressedImage!
    }
}

extension UIImageView {
    func downloadImage(from url: String) {
        if let webUrl = URL(string: url) {
            let urlRequest = URLRequest(url: webUrl)
            let task = URLSession.shared.dataTask(with: urlRequest)  { (imgData, responce, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    if let data = imgData {
                        self.image = UIImage(data: data)?.decompressedImage
                    }
                }
            }
            task.resume()
        }
    }
}
