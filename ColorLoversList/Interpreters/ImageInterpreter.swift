//
//  ImageInterpreter.swift
//  ColorLoversList
//
//  Created by Grzesiek on 13/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import UIKit

class ImageInterpreter: NetworkResponseInterpreter {
    
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?, successStatusCode: Int) -> Response<UIImage, ResponseError> {
        
        if let _ = error { return Response.error(ResponseError.connectionError) }
        guard response?.statusCode == successStatusCode else {
            return Response.error(ResponseError.invalidResponseError)
        }
        guard let data = data else { return Response.error(ResponseError.invalidResponseError) }
        guard let image = UIImage(data: data, scale: UIScreen.main.scale) else { return Response.error(ResponseError.decodeError) }
        return Response.success(image)
    }
}
