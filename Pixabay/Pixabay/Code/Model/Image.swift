//
//  Image.swift
//  Pixabay
//
//  Created by Nickelfox on 02/03/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

class Image: NSObject {
    var imageUrl: String = ""
    var width: Int = 0
    var height: Int = 0
    var previewWidth: Int = 0
    var previewHeight: Int = 0
    
    
    static func parse(json: [String: AnyObject]) -> Image? {
        if let imageUrl = json["webformatURL"] as? String, let width = json["imageWidth"] as? Int, let height = json["imageHeight"] as? Int, let pWidth = json["previewWidth"] as? Int, let pHeight = json["previewHeight"] as? Int   {
            let image = Image()
            image.imageUrl = imageUrl
            image.width = width
            image.height = height
            image.previewWidth = pWidth
            image.previewHeight = pHeight
            return image
        }
        return nil
    }
    
    class func fetchImage(sourceUrl: String?, completion: @escaping ([Image]) -> Void) {
        if let url = sourceUrl {
            let webUrl = "https://pixabay.com/api/?key=4709065-7f6bc616c8947e227146bc2a4&q=\(url)&image_type=photo&pretty=true&per_page=200"
            Network.shared.fetch(from: webUrl) { (json, errorMessage) in
                if let _ = errorMessage {
                    completion([])
                }
                guard let json = json as? [String: AnyObject], let imagesJson = json["hits"] as? [[String: AnyObject]] else {
                    completion([])
                    return
                }
                var images = [Image]()
                for imageJson in imagesJson {
                    if let image = Image.parse(json: imageJson) {
                        images.append(image)
                    }
                }
                completion(images)
            }
        }
    }
    
    func heightForComment(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: "").boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
}
