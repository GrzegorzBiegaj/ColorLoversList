//
//  LoversInterpreter.swift
//  ColorLoversList
//
//  Created by Grzesiek on 13/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import Foundation

class LoversInterpreter: NetworkResponseInterpreter {
    
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?, successStatusCode: Int) -> Response<[Lover], ResponseError> {
        
        if let _ = error { return Response.error(ResponseError.connectionError) }
        guard response?.statusCode == successStatusCode else {
            return Response.error(ResponseError.invalidResponseError)
        }
        guard let data = data else { return Response.error(ResponseError.invalidResponseError) }
        guard let response = try? JSONDecoder().decode([Lover].self, from: data) else {
            return Response.error(ResponseError.decodeError)
        }
        return Response.success(response)
    }
}
