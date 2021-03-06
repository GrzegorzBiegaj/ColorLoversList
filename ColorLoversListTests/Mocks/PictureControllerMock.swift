//
//  PictureControllerMock.swift
//  ColorLoversListTests
//
//  Created by Grzegorz Biegaj on 19.05.18.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import Foundation
@testable import ColorLoversList

class PictureControllerMock: PictureControllerProtocol {

    var numberOfElements: Int
    var pictures: [Picture] = []
    var response: Result<[Picture], ResponseError>

    init (response: Result<[Picture], ResponseError>, numberOfElements: Int = 10) {
        self.response = response
        self.numberOfElements = numberOfElements
    }

    func pictures(offset: Int, userName: String, pictureType: PictureType, handler: @escaping (Result<[Picture], ResponseError>) -> ()) {
        handler(response)
    }

    func clearCahe() {
        pictures = []
    }

    
}
