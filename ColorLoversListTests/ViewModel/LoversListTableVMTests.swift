//
//  LoversListTableVMTests.swift
//  ColorLoversListTests
//
//  Created by Grzegorz Biegaj on 19.05.18.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import XCTest
@testable import ColorLoversList

class LoversListTableVMTests: XCTestCase {

    func testFetchEntriesError() {

        let loverController = LoverControllerMock(response: Result.failure(.invalidResponseError))
        let viewModel = LoversListTableVM(loverController: loverController)

        viewModel.fetchEntries { response in
            switch response {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.invalidResponseError)
            }
        }
    }

    func testFetchEntriesSuccess() {

        let lovers = [Lover(userName: "Etienne", numColors: 100, numPalettes: 23, numPatterns: 198, rating: 1000),
                       Lover(userName: "Jean", numColors: 12, numPalettes: 78, numPatterns: 300, rating: 900)]
        let loverController = LoverControllerMock(response: Result.success(lovers))
        let viewModel = LoversListTableVM(loverController: loverController)

        XCTAssertEqual(viewModel.listOffset, 0)

        viewModel.fetchEntries { response in
            switch response {
            case .success(let lov):
                XCTAssertEqual(lov, lovers)
            case .failure(_):
                XCTFail()
            }
        }
        XCTAssertEqual(viewModel.lovers, lovers)
        XCTAssertEqual(viewModel.listOffset, loverController.numberOfElements)

        viewModel.fetchEntries { response in
            switch response {
            case .success(let lov):
                XCTAssertEqual(lov, lovers)
            case .failure(_):
                XCTFail()
            }
        }
        XCTAssertEqual(viewModel.lovers, lovers)
        XCTAssertEqual(viewModel.listOffset, loverController.numberOfElements * 2)

        viewModel.clearData()
        XCTAssertEqual(viewModel.listOffset, 0)
    }

    func testShouldFetchNextExtries() {

        let lovers = [Lover(userName: "Etienne", numColors: 100, numPalettes: 23, numPatterns: 198, rating: 1000),
                      Lover(userName: "Jean", numColors: 12, numPalettes: 78, numPatterns: 300, rating: 900)]
        let loverController = LoverControllerMock(response: Result.success(lovers))
        let viewModel = LoversListTableVM(loverController: loverController)
        viewModel.fetchEntries { response in
            switch response {
            case .success(let lov):
                XCTAssertEqual(lov, lovers)
            case .failure(_):
                XCTFail()
            }
        }
        XCTAssertFalse(viewModel.shouldFetchNextExtries(index: 0))
        XCTAssertFalse(viewModel.shouldFetchNextExtries(index: 100))
        XCTAssertTrue(viewModel.shouldFetchNextExtries(index: 1))
    }

    func testLoverName() {

        let lovers = [Lover(userName: "Etienne", numColors: 100, numPalettes: 23, numPatterns: 198, rating: 1000),
                      Lover(userName: "Jean", numColors: 12, numPalettes: 78, numPatterns: 300, rating: 900),
                      Lover(userName: nil, numColors: 12, numPalettes: 78, numPatterns: 300, rating: 900)]
        let loverController = LoverControllerMock(response: Result.success(lovers))
        let viewModel = LoversListTableVM(loverController: loverController)
        viewModel.fetchEntries { response in
            switch response {
            case .success(let lov):
                XCTAssertEqual(lov, lovers)
            case .failure(_):
                XCTFail()
            }
        }
        XCTAssertEqual(viewModel.loverName(index: 0), "Etienne (rating: \(1000))")
        XCTAssertEqual(viewModel.loverName(index: 1), "Jean (rating: \(900))")
        XCTAssertEqual(viewModel.loverName(index: 3), nil)
        XCTAssertEqual(viewModel.loverName(index: 4), nil)
        XCTAssertEqual(viewModel.loverName(index: -1), nil)
    }

    func testLoverDetails() {

        let lovers = [Lover(userName: "Etienne", numColors: 100, numPalettes: 23, numPatterns: 198, rating: 1000),
                      Lover(userName: "Jean", numColors: 12, numPalettes: 78, numPatterns: 300, rating: 900),
                      Lover(userName: "Test3", numColors: nil, numPalettes: 78, numPatterns: 300, rating: 900),
                      Lover(userName: "Test4", numColors: 12, numPalettes: nil, numPatterns: 300, rating: 900),
                      Lover(userName: "Test5", numColors: 12, numPalettes: 78, numPatterns: nil, rating: 900)]
        let loverController = LoverControllerMock(response: Result.success(lovers))
        let viewModel = LoversListTableVM(loverController: loverController)
        viewModel.fetchEntries { response in
            switch response {
            case .success(let lov):
                XCTAssertEqual(lov, lovers)
            case .failure(_):
                XCTFail()
            }
        }
        XCTAssertEqual(viewModel.loverDetails(index: 0), "Patterns: \(198), Palletes: \(23), Colors: \(100)")
        XCTAssertEqual(viewModel.loverDetails(index: 1), "Patterns: \(300), Palletes: \(78), Colors: \(12)")
        XCTAssertEqual(viewModel.loverDetails(index: 2), nil)
        XCTAssertEqual(viewModel.loverDetails(index: 3), nil)
        XCTAssertEqual(viewModel.loverDetails(index: 4), nil)
        XCTAssertEqual(viewModel.loverDetails(index: 5), nil)
    }

    func testNumberOfPictures() {

        let lovers = [Lover(userName: "Etienne", numColors: 100, numPalettes: 23, numPatterns: 198, rating: 1000),
                      Lover(userName: "Jean", numColors: 12, numPalettes: 78, numPatterns: 300, rating: 900)]
        let loverController = LoverControllerMock(response: Result.success(lovers))
        let viewModel = LoversListTableVM(loverController: loverController)
        viewModel.fetchEntries { response in
            switch response {
            case .success(let lov):
                XCTAssertEqual(lov, lovers)
                XCTAssertEqual(viewModel.numberOfPictures(lover: lov[0], pictureType: .pattern), 198)
                XCTAssertEqual(viewModel.numberOfPictures(lover: lov[0], pictureType: .color), 100)
                XCTAssertEqual(viewModel.numberOfPictures(lover: lov[0], pictureType: .palette), 23)
                XCTAssertEqual(viewModel.numberOfPictures(lover: nil, pictureType: .pattern), 0)
                XCTAssertEqual(viewModel.numberOfPictures(lover: lov[0], pictureType: nil), 0)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
}
