//
//  PictureController.swift
//  ColorLoversList
//
//  Created by Grzesiek on 09/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import Foundation

protocol PictureControllerProtocol {

    var numberOfElements: Int { get }
    var pictures: [Picture] { get }

    func pictures(offset: Int, userName: String, pictureType: PictureType, handler: @escaping (Response<[Picture], ResponseError>) -> ())
    func clearCahe()
}

class PictureController: PictureControllerProtocol {
    
    var numberOfElements = 100
    var pictures: [Picture] = []

    var connection: RequestConnectionProtocol
    
    init (connection: RequestConnectionProtocol = RequestConnection()) {
        self.connection = connection
    }
    
    func pictures(offset: Int, userName: String, pictureType: PictureType, handler: @escaping (Response<[Picture], ResponseError>) -> ()) {
        
        let request = PicturesRequest(offset: offset, number: numberOfElements, userName: userName, pictureType: pictureType)
        
        connection.performRequest(request: request) { (response) in
            
            switch response {
            case .success(let pictures):
                self.pictures += pictures
                handler(.success(self.pictures))
            case .error(let error):
                handler(.error(error))
            }
        }
    }
    
    func clearCahe() {
        
        pictures = []
    }
}
