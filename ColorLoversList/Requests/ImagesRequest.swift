//
//  ImagesRequest.swift
//  ColorLoversList
//
//  Created by Grzesiek on 10/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import UIKit

struct ImagesRequest: RequestProtocol {
    
    let url: String
    
    // MARK: Request protocol
    
    var endpoint: String { return url }
 
    let interpreter: ImageInterpreter = ImageInterpreter()
}
