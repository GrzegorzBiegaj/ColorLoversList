//
//  LoversListTableVM.swift
//  ColorLoversList
//
//  Created by Grzegorz Biegaj on 18.05.18.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import Foundation

class LoversListTableVM {

    fileprivate let loverController: LoverControllerProtocol

    private(set) var listOffset = 0
    var lovers: [Lover] = []

    init (loverController: LoverControllerProtocol = LoverController()) {
        self.loverController = loverController
    }

    func fetchEntries(handler: @escaping (Result<[Lover], ResponseError>) -> ()) {
        loverController.lovers(offset: listOffset) { (response) in
            switch response {
            case .success(let lovers):
                self.listOffset += self.loverController.numberOfElements
                self.lovers = lovers
                handler(.success(self.lovers))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    func clearData() {
        loverController.clearCahe()
        listOffset = 0
    }

    func shouldFetchNextExtries(index: Int) -> Bool {
        return lovers.count > 0 && index == lovers.count - 1
    }

    func loverName(index: Int) -> String? {
        guard index >= 0 && index < lovers.count else { return nil }
        let lover = lovers[index]
        guard let userName = lover.userName, let rating = lover.rating  else { return nil }
        return "\(userName) (rating: \(rating))"
    }

    func loverDetails(index: Int) -> String? {
        guard index >= 0 && index < lovers.count else { return nil }
        let lover = lovers[index]
        guard let numPatterns = lover.numPatterns,
            let numPalettes = lover.numPalettes,
            let numColors = lover.numColors else { return nil }
        return "Patterns: \(numPatterns), Palletes: \(numPalettes), Colors: \(numColors)"
    }

    func numberOfPictures(lover: Lover?, pictureType: PictureType?) -> Int {
        guard let lover = lover, let pictureType = pictureType else { return 0 }
        switch pictureType {
        case .pattern: return lover.numPatterns ?? 0
        case .palette: return lover.numPalettes ?? 0
        case .color: return lover.numColors ?? 0
        }
    }


}
