//
//  LoverControllerMock.swift
//  ColorLoversListTests
//
//  Created by Grzegorz Biegaj on 19.05.18.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import Foundation
@testable import ColorLoversList

class LoverControllerMock: LoverControllerProtocol {

    var numberOfElements = 10
    var lovers: [Lover] = []
    var connection: RequestConnectionProtocol = NetworkingMock()
    var response: Response<[Lover], ResponseError>

    init (response: Response<[Lover], ResponseError>) {
        self.response = response
    }

    func lovers(offset: Int, handler: @escaping (Response<[Lover], ResponseError>) -> ()) {
        handler(response)
    }

    func sortLoversByRatingAndName(lovers: [Lover]) -> [Lover] {
        return lovers
    }

    func clearCahe() {
        lovers = []
    }


}
