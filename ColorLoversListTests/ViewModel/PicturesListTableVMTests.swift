//
//  PicturesListTableVMTests.swift
//  ColorLoversListTests
//
//  Created by Grzegorz Biegaj on 19.05.18.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import XCTest
@testable import ColorLoversList

class PicturesListTableVMTests: XCTestCase {
    
    func testFetchEntriesError() {

        let pictureController = PictureControllerMock(response: Result.failure(.invalidResponseError))
        let viewModel = PicturesListTableVM(pictureController: pictureController)

        viewModel.fetchEntries(userName: "test", pictureType: .color) { response in
            switch response {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.invalidResponseError)
            }
        }
    }

    func testFetchEntriesSuccess() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: "2017-01-13 12:22:33")!

        let pictures = [Picture(title: "test1", dateCreated: date, imageUrl: "imageUrl", numVotes: 123),
                        Picture(title: "test2", dateCreated: date, imageUrl: "imageUrl2", numVotes: 1000)]

        let pictureController = PictureControllerMock(response: Result.success(pictures))
        let viewModel = PicturesListTableVM(pictureController: pictureController)
        viewModel.numberOfPictures = pictures.count

        XCTAssertEqual(viewModel.listOffset, 0)

        viewModel.fetchEntries(userName: "test", pictureType: .color) { response in
            switch response {
            case .success(let pic):
                XCTAssertEqual(pic, pictures)
            case .failure(_):
                XCTFail()
            }
        }

        XCTAssertEqual(viewModel.pictures, pictures)
        XCTAssertEqual(viewModel.listOffset, pictureController.numberOfElements)

        viewModel.fetchEntries(userName: "test", pictureType: .color) { response in
            switch response {
            case .success(let pic):
                XCTAssertEqual(pic, pictures)
            case .failure(_):
                XCTFail()
            }
        }
        XCTAssertEqual(viewModel.pictures, pictures)
        XCTAssertEqual(viewModel.listOffset, pictureController.numberOfElements * 2)

        viewModel.clearData()
        XCTAssertEqual(viewModel.listOffset, 0)
    }

    func testShouldFetchNextExtries() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: "2017-01-13 12:22:33")!

        let pictures = [Picture(title: "test1", dateCreated: date, imageUrl: "imageUrl", numVotes: 123),
                        Picture(title: "test2", dateCreated: date, imageUrl: "imageUrl2", numVotes: 1000)]

        let pictureController = PictureControllerMock(response: Result.success(pictures), numberOfElements: 2)
        let viewModel = PicturesListTableVM(pictureController: pictureController)
        viewModel.numberOfPictures = 10

        XCTAssertEqual(viewModel.listOffset, 0)

        viewModel.fetchEntries(userName: "test", pictureType: .color) { response in
            switch response {
            case .success(let pic):
                XCTAssertEqual(pic, pictures)
            case .failure(_):
                XCTFail()
            }
        }
        XCTAssertTrue(viewModel.shouldFetchNextExtries(index: 1))
        XCTAssertFalse(viewModel.shouldFetchNextExtries(index: 2))
    }

    func testPictureName() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: "2017-01-13 12:22:33")!

        let pictures = [Picture(title: "test1", dateCreated: date, imageUrl: "imageUrl", numVotes: 123),
                        Picture(title: "test2", dateCreated: date, imageUrl: "imageUrl2", numVotes: 1000)]

        let pictureController = PictureControllerMock(response: Result.success(pictures), numberOfElements: 2)
        let viewModel = PicturesListTableVM(pictureController: pictureController)
        viewModel.numberOfPictures = 10

        XCTAssertEqual(viewModel.listOffset, 0)

        viewModel.fetchEntries(userName: "test", pictureType: .color) { response in
            switch response {
            case .success(let pic):
                XCTAssertEqual(pic, pictures)
            case .failure(_):
                XCTFail()
            }
        }
        XCTAssertEqual(viewModel.pictureName(index: 0), "test1")
        XCTAssertEqual(viewModel.pictureName(index: 1), "test2")
        XCTAssertEqual(viewModel.pictureName(index: 3), nil)
    }

    func testPictureDetails() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: "2017-01-13 12:22:33")!

        let pictures = [Picture(title: "test1", dateCreated: date, imageUrl: "imageUrl", numVotes: 123),
                        Picture(title: "test2", dateCreated: date, imageUrl: "imageUrl2", numVotes: 1000)]

        let pictureController = PictureControllerMock(response: Result.success(pictures), numberOfElements: 2)
        let viewModel = PicturesListTableVM(pictureController: pictureController)
        viewModel.numberOfPictures = 10

        XCTAssertEqual(viewModel.listOffset, 0)

        viewModel.fetchEntries(userName: "test", pictureType: .color) { response in
            switch response {
            case .success(let pic):
                XCTAssertEqual(pic, pictures)
            case .failure(_):
                XCTFail()
            }
        }
        XCTAssertEqual(viewModel.pictureDetails(index: 0), "Date: 2017.01.13 12:22:33, Votes: 123")
        XCTAssertEqual(viewModel.pictureDetails(index: 1), "Date: 2017.01.13 12:22:33, Votes: 1000")
        XCTAssertEqual(viewModel.pictureDetails(index: 3), nil)
    }
    
}
