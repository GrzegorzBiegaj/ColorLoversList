//
//  PictureVC.swift
//  ColorLoversList
//
//  Created by Grzesiek on 10/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import UIKit

class PictureVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var picture: Picture?
    
    fileprivate var imageView: UIImageView?
    
    // MARK: Controllers
    
    fileprivate lazy var imageController: ImageController = ImageController()
    
    // MARK: App life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = picture?.title
        loadImage(frame: view.frame)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if let imageView = imageView {
            
            imageView.removeFromSuperview()
            loadImage(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        }
    }
    
    // MARK: Show image
    
    fileprivate func loadImage(frame: CGRect) {
        
        if let url = picture?.imageUrl {
            
            if let image = imageController.imageFromCache(url: url) {
                
                showImage(image: image, frame: frame)
            } else {
                
                imageController.image(url: url, handler: { (response) in
                    switch response {
                    case .success(let image):
                        self.showImage(image: image, frame: frame)
                        
                    case .error(_): break
                    }
                })
            }
        }
    }
    
    fileprivate func showImage(image: UIImage, frame: CGRect) {
        
        activityIndicator.stopAnimating()
        
        imageView = UIImageView(frame: frame)
        if let imageView = imageView {
            imageView.contentMode = .topLeft
            imageView.backgroundColor = UIColor(patternImage: image)
            view.addSubview(imageView)
        }
    }
    
}
