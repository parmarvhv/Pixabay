//
//  ViewController.swift
//  Pixabay
//
//  Created by Nickelfox on 02/03/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import AVFoundation
import UIKit

fileprivate let sequeId = "imageSegue"
fileprivate let ImageViewControllerId = "ImageViewController"
fileprivate let presentAnimationController = PresentAnimationController()
fileprivate let dismissAnimationController = DismissAnimationController()
fileprivate let swipeInteractionController = SwipeInteractionController()
//fileprivate let cubePresentAnimationController = CubePresentAnimationController()

class PhotoStreamViewController: UIViewController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    var imageUrl: String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var thumbnailView: UIImageView!
    @IBOutlet var displayImageUiView: UIView!
    
    var images: [Image] = []
    var noOfColumns: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
    }
    
    func setupUIElements() {
        collectionView.dataSource = self
        collectionView.delegate = self
        searchField.delegate = self
        if let layout = collectionView?.collectionViewLayout as? PintrestLayout {
            layout.delegate = self
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if UIDevice.current.orientation == .portrait {
            noOfColumns = 2
        } else {
            noOfColumns = 4
        }
        if let layout = self.collectionView.collectionViewLayout as?  PintrestLayout {
            layout.numberOfColumns = noOfColumns
            layout.reset()
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == sequeId , let destinationVC = segue.destination as? ImageViewController {
//            destinationVC.imageUrl = imageUrl
//            destinationVC.transitioningDelegate = self
//        }
//    }
    
}

// MARK: PIntrest Layout Delegate
extension PhotoStreamViewController: PintrestLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let photo = self.images[indexPath.item]
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: CGSize(width: (photo.width) , height: (photo.height)), insideRect: boundingRect)
        return rect.size.height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! PhotoCell
        cell.populateCell(imageUrl: images[indexPath.item].imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageUrl = images[indexPath.item].imageUrl
        
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ImageViewControllerId) as! ImageViewController
        destinationVC.imageUrl = images[indexPath.item].imageUrl
        destinationVC.transitioningDelegate = self
        swipeInteractionController.wireToViewController(viewController: destinationVC)
        self.present(destinationVC, animated: true, completion: nil)
        
        
//        displayImageUiView.isHidden = false
//        thumbnailView.zoomIn(duration: 0.2)
//    
//        let cellRect: CGRect = collectionView.layoutAttributesForItem(at: indexPath)!.frame
//        let frame = CGRect(origin: CGPoint(x: cellRect.origin.x/4, y: cellRect.origin.y/4), size: thumbnailView.frame.size)
//        
//        self.thumbnailView.frame = thumbnailView.convert(frame, from: collectionView.cellForItem(at: indexPath))
//        
//        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
//            self.thumbnailView.center = collectionView.center
//        }, completion: { (finished) in })
//        
//        let image = images[indexPath.item]
//        if let imageUrl = image.imageUrl {
//            thumbnailView.downloadImage(from: imageUrl)
//            //thumbnailView.frame.size = CGSize(width: image.previewWidth, height: image.previewHeight)
//        }
//        thumbnailView.layoutIfNeeded()
//    }
    }
}

//MARK: Text Field Delegate
extension PhotoStreamViewController:  UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateToTop()
        let searchQuery = searchField.text!.replacingOccurrences(of: " ", with: "+")
        Image.fetchImage(sourceUrl: searchQuery){ [weak self](images) in
            if images.count > 0 {
                self?.images = images
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } else {
                let message = "No images found for your search"
                let alert = UIAlertController(title: "Sorry !", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return false;
    }
    
    func animateToTop() {
        searchFieldHeightConstraint.constant = 5
        UIView.animate(withDuration: 0.8, animations: {
            self.view.layoutIfNeeded()
        }) { _  in
            self.collectionView.isHidden = false
        }
    }
}
extension PhotoStreamViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentAnimationController.originFrame = self.view.frame
        return presentAnimationController
//       cubePresentAnimationController.originFrame = self.view.frame
//        cubePresentAnimationController.reverse = true
//        return cubePresentAnimationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissAnimationController.destinationFrame = self.view.frame
        return dismissAnimationController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
    }
}

extension UIView {
    func zoomIn( duration: TimeInterval) {
        self.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        })
    }
    
    func zoomOut(duration: TimeInterval ) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        })
    }
}

