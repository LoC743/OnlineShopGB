//
//  RequestFactory.swift
//  OnlineShopGB
//
//  Created by Alexey on 22.06.2021.
//

import Alamofire
import SwiftyBeaver

class RequestFactory {
    
    func makeErrorParser() -> AbstractErrorParser {
        return ErrorParser()
    }
    
    lazy var commonSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let manager = Session(configuration: configuration)
        
        return manager
    }()
    
    let sessionQueue = DispatchQueue.global(qos: .utility)
    
    func makeAuthRequestFatory() -> AuthRequestFactory {
        guard let url = URL(string: StringResources.baseURL) else {
            SwiftyBeaver.error("Creating Auth URL error!")
            fatalError("Creating Auth URL error!")
        }
        let errorParser = makeErrorParser()
        
        return Auth(baseURL: url, errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }
    
    func makeProductRequestFatory() -> ProductRequestFactory {
        guard let url = URL(string: StringResources.baseURL + StringResources.productAddURL) else {
            SwiftyBeaver.error("Creating Product URL error!")
            fatalError("Creating Product URL error!")
        }
        let errorParser = makeErrorParser()
        
        return Product(baseURL: url, errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }
    
    func makeReviewRequestFatory() -> ReviewRequestFactory {
        guard let url = URL(string: StringResources.baseURL + StringResources.reviewAddURL) else {
            SwiftyBeaver.error("Creating Review URL error!")
            fatalError("Creating Review URL error!")
        }
        let errorParser = makeErrorParser()
        
        return Review(baseURL: url, errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }
    
    func makeCartRequestFatory() -> CartRequestFactory {
        guard let url = URL(string: StringResources.baseURL + StringResources.cartAddURL) else {
            SwiftyBeaver.error("Creating Cart URL error!")
            fatalError("Creating Cart URL error!")
        }
        let errorParser = makeErrorParser()
        
        return Cart(baseURL: url, errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }
}
