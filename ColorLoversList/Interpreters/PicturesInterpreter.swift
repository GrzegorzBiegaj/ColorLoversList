//
//  PicturesInterpreter.swift
//  ColorLoversList
//
//  Created by Grzesiek on 13/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import Foundation

class PicturesInterpreter: NetworkResponseInterpreter {
    
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?, successStatusCode: Int) -> Response<[Picture], ResponseError> {
        
        if let _ = error { return Response.error(ResponseError.connectionError) }
        guard response?.statusCode == successStatusCode else {
            return Response.error(ResponseError.invalidResponseError)
        }
        guard let data = data else { return Response.error(ResponseError.invalidResponseError) }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.date(from: dateStr) ?? Date(timeIntervalSince1970: 0)
        })
        guard let response = try? decoder.decode([Picture].self, from: data) else {
            return Response.error(ResponseError.decodeError)
        }
        return Response.success(response)
    }
}
