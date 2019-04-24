//
//  ImageController.swift
//  ColorLoversList
//
//  Created by Grzesiek on 10/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import UIKit

class ImageController {
    
    let connection: RequestConnectionProtocol
    
    lazy var inMemoryStorage = InMemoryStorage.sharedInstance
    
    init (connection: RequestConnectionProtocol = RequestConnection()) {
        self.connection = connection
    }
    
    func image(url: String, handler: @escaping (Result<UIImage, ResponseError>) -> ()) {
        
        let request = ImagesRequest(url: url)
        
        connection.performRequest(request: request) { (response) in
            
            switch response {
            case .success(let image):
                self.addImageToCache(image: image, url: url)
                handler(response)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    // MARK: Images cache access
    
    func imageFromCache(url: String) -> UIImage? {
        
        if let imagesData = restoreImages(), let imagesDisctionary = imagesData.imagesDisctionary {
            return imagesDisctionary[url]
        }
        return nil
    }
    
    func addImageToCache(image: UIImage?, url: String) {
        
        if let image = image {
            
            var newImagesData = ImagesData()
            
            if let imagesData = self.restoreImages() {
                newImagesData = imagesData
            } else {
                let imagesDisctionary = [String: UIImage]()
                newImagesData.imagesDisctionary = imagesDisctionary
            }
            newImagesData.imagesDisctionary![url] = image
            self.inMemoryStorage.store(newImagesData)
        }
    }
    
    fileprivate func restoreImages() -> ImagesData? {
        
        let imagesData: ImagesData? = inMemoryStorage.tryRestore()
        return imagesData
    }
}
