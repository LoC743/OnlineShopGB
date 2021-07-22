//
//  DataRequest.swift
//  OnlineShopGB
//
//  Created by Alexey on 22.06.2021.
//

import Foundation
import Alamofire
import SwiftyBeaver

class CustomDecodableSerializer<T: Decodable>: DataResponseSerializerProtocol {
    private let errorParser: AbstractErrorParser
    
    init(errorParser: AbstractErrorParser) {
        self.errorParser = errorParser
    }
    
    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        SwiftyBeaver.info("Starting to decode JSON from \(String(describing: request))")
        if let error = errorParser.parse(response: response, data: data, error: error) {
            SwiftyBeaver.error("Error parsing JSON from \(String(describing: request))")
            throw error
        }
        
        do {
            let data = try DataResponseSerializer().serialize(
                request: request,
                response: response,
                data: data,
                error: error
            )
            let value = try JSONDecoder().decode(T.self, from: data)
            
            return value
        } catch {
            let customError = errorParser.parse(error)
            SwiftyBeaver.error("\(customError)")
            throw customError
        }
    }
}

extension DataRequest {
    @discardableResult
    func responseCodable<T: Decodable>(
        errorParser: AbstractErrorParser,
        queue: DispatchQueue = .main,
        completionHandler: @escaping (AFDataResponse<T>) -> Void)
    -> Self {
        let responseSerializer = CustomDecodableSerializer<T>(errorParser: errorParser)
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
