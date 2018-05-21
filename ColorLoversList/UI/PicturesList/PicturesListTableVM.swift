//
//  PicturesListTableVM.swift
//  ColorLoversList
//
//  Created by Grzegorz Biegaj on 18.05.18.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import Foundation

class PicturesListTableVM {

    fileprivate let pictureController: PictureControllerProtocol
    private(set) var listOffset = 0
    private(set) var listShorterThanExpected = false

    var pictures: [Picture] = []
    var numberOfPictures: Int?

    init (pictureController: PictureControllerProtocol = PictureController()) {
        self.pictureController = pictureController
    }

    func fetchEntries(userName: String, pictureType: PictureType, handler: @escaping (Response<[Picture], ResponseError>) -> ()) {

        pictureController.pictures(offset: listOffset, userName: userName, pictureType: pictureType) { (response) in
            switch response {
            case .success(let pictures):
                // Protect against less elements than expected
                if pictures.count - self.listOffset != self.pictureController.numberOfElements {
                    self.listShorterThanExpected = true
                }
                self.listOffset += self.pictureController.numberOfElements
                self.pictures = pictures
                handler(.success(self.pictures))
            case .error(let error):
                handler(.error(error))
            }
        }
    }

    func clearData() {

        pictureController.clearCahe()
        listOffset = 0
    }
    
    func shouldFetchNextExtries(index: Int) -> Bool {
        guard let numberOfPictures = numberOfPictures else { return false }
        return index == pictures.count - 1 &&
            pictures.count < numberOfPictures &&
            !listShorterThanExpected
    }

    func pictureName(index: Int) -> String? {
        guard index >= 0 && index < pictures.count else { return nil }
        return pictures[index].title
    }

    func pictureDetails(index: Int) -> String? {

        guard index >= 0 && index < pictures.count else { return nil }
        let picture = pictures[index]
        guard let numVotes = picture.numVotes else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        var dateString = "???"
        if let dateCreated = picture.dateCreated {
            dateString = dateFormatter.string(from: dateCreated as Date)
        }
        return "Date: \(dateString), Votes: \(numVotes)"
    }

}

