//
//  ImageInterpreterTests.swift
//  ColorLoversListTests
//
//  Created by Grzesiek on 13/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import XCTest
@testable import ColorLoversList

class ImageInterpreterTests: XCTestCase {
    
    func testImageInterpreterValidData() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let successStatusCode = 200
        
        let image = UIImage.imageWithColor(color: .red, size: CGSize(width: 100, height: 100))
        let data = image.pngData()
        
        let imageInterpreter = ImageInterpreter()
        let resp = imageInterpreter.interpret(data: data, response: response, error: nil, successStatusCode: successStatusCode)
        switch resp {
        case .success(let respImage):
            XCTAssertEqual(respImage.size, image.size)
        case .error(_):
            XCTFail()
        }
    }
    
    func testImageInterpreterInvalidResponse() {
        
        let response = HTTPURLResponse(url: URL(string: "test")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        let successStatusCode = 400
        let imageInterpreter = ImageInterpreter()
        let resp = imageInterpreter.interpret(data: nil, response: response, error: nil, successStatusCode: successStatusCode)
        switch resp {
        case .success(_):
            XCTFail()
        case .error(let responseError):
            XCTAssertEqual(responseError, ResponseError.invalidResponseError)
        }
    }
    
    func testImageInterpreterError() {
        
        let response = HTTPURLResponse()
        let error = NSError(domain: "test", code: 100, userInfo: nil)
        let successStatusCode = 400
        
        let imageInterpreter = ImageInterpreter()
        let resp = imageInterpreter.interpret(data: nil, response: response, error: error, successStatusCode: successStatusCode)
        switch resp {
        case .success(_):
            XCTFail()
        case .error(let responseError):
            XCTAssertEqual(responseError, ResponseError.connectionError)
        }
    }
}
