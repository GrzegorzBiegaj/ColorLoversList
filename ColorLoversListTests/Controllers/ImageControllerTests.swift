//
//  ImageControllerTests.swift
//  ColorLoversListTests
//
//  Created by Grzesiek on 13/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import XCTest
@testable import ColorLoversList

class ImageControllerTests: XCTestCase {
    
    func testPositiveResponse() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let image = UIImage.imageWithColor(color: .red, size: CGSize(width: 100, height: 100))
        let data = image.pngData()
        
        let imageController = ImageController(connection: NetworkingMock(data: data, error: nil, response: response))
        imageController.image(url: "image") { (resp) in
            switch resp {
            case .success(let respImage):
                XCTAssertEqual(respImage.size, image.size)
            case .error(_):
                XCTFail()
            }
        }
    }
    
    func testNegativeResponse() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        let imageController = ImageController(connection: NetworkingMock(data: nil, error: nil, response: response))
        imageController.image(url: "image") { (resp) in
            switch resp {
            case .success(_):
                XCTFail()
            case .error(let error):
                XCTAssertEqual(error, ResponseError.invalidResponseError)
            }
        }
    }
    
    func testNegativeError() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let imageController = ImageController(connection: NetworkingMock(data: nil, error: nil, response: response))
        imageController.image(url: "image") { (resp) in
            switch resp {
            case .success(_):
                XCTFail()
            case .error(let error):
                XCTAssertEqual(error, ResponseError.invalidResponseError)
            }
        }
    }
    
    func testCacheOperations() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let imageMock = UIImage.imageWithColor(color: .red, size: CGSize(width: 100, height: 100))
        let imageMock2 = UIImage.imageWithColor(color: .red, size: CGSize(width: 100, height: 100))
        let imageController = ImageController(connection: NetworkingMock(data: nil, error: nil, response: response))
        
        XCTAssertNil(imageController.imageFromCache(url: "imageUrl"))
        imageController.addImageToCache(image: imageMock, url: "imageUrl")
        imageController.addImageToCache(image: imageMock2, url: "imageUrl2")
        
        XCTAssertEqual(imageController.imageFromCache(url: "imageUrl"), imageMock)
        XCTAssertNotEqual(imageController.imageFromCache(url: "imageUrl"), imageMock2)
        XCTAssertEqual(imageController.imageFromCache(url: "imageUrl2"), imageMock2)
        XCTAssertNotEqual(imageController.imageFromCache(url: "imageUrl2"), imageMock)
        XCTAssertNil(imageController.imageFromCache(url: "notExistsUrl"))
    }
}
