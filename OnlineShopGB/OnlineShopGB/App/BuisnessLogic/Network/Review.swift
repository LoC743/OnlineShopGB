//
//  Review.swift
//  OnlineShopGB
//
//  Created by Alexey on 02.07.2021.
//

import Alamofire

class Review: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl: URL
    
    init(
        baseURL: URL,
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)
    ) {
        self.baseUrl = URL(string: baseURL.absoluteString + "review/")!
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Review: ReviewRequestFactory {
    func add(userID: Int, productID: Int, text: String, completionHandler: @escaping (AFDataResponse<AddReviewResult>) -> Void) {
        let requestModel = Add(baseUrl: self.baseUrl, userID: userID, productID: productID, text: text)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func remove(commentID: String, completionHandler: @escaping (AFDataResponse<RemoveReviewResult>) -> Void) {
        let requestModel = Remove(baseUrl: self.baseUrl, commentID: commentID)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    
    func get(productID: Int, completionHandler: @escaping (AFDataResponse<Array<ReviewResult>>) -> Void) {
        let requestModel = Get(baseUrl: self.baseUrl, productID: productID)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
    

}

extension Review {
    struct Add: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "add"
    
        let userID: Int
        let productID: Int
        let text: String
        
        var parameters: Parameters? {
            return [
                "user_id": userID,
                "product_id": productID,
                "text": text
            ]
        }
    }
    
    struct Remove: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "remove"
    
        let commentID: String
        
        var parameters: Parameters? {
            return [
                "comment_id": commentID
            ]
        }
    }
    
    struct Get: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = ""
    
        let productID: Int
        
        var parameters: Parameters? {
            return [
                "product_id": productID
            ]
        }
    }
}


