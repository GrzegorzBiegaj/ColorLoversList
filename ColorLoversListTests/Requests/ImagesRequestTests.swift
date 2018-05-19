//
//  ImagesRequestTests.swift
//  ColorLoversListTests
//
//  Created by Grzesiek on 12/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import XCTest
@testable import ColorLoversList

class ImagesRequestTests: XCTestCase {
    
    func testImagesRequest() {
        
        let url = "http://colourlovers.com.s3.amazonaws.com/images/patterns/5068/5068906.png"
        
        let imagesRequest = ImagesRequest(url: url)
        
        XCTAssertEqual(imagesRequest.successStatusCode, 200)
        XCTAssertEqual(imagesRequest.httpMethod, .get)
        XCTAssertEqual(imagesRequest.endpoint, url)
        XCTAssertNil(imagesRequest.requestParameters)
        XCTAssertNil(imagesRequest.bodyParameters)
        XCTAssertNil(imagesRequest.headers)
    }
}
