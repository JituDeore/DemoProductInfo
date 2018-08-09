//
//  APIService.swift
//  Assignment
//
//  Created by Jitendra Deore on 09/08/18.
//  Copyright © 2018 Jitendra Deore. All rights reserved.
//

import Foundation

protocol APIParser {
    associatedtype ModalType
    static func parse(response : Any) -> Self?
}

// Convenience protocol for codable and apiparsing
protocol CodableAPIParser : Codable,APIParser{
}

enum HTTPMethod {
    case GET
    case POST
    case PUT
    case DELETE
}

enum Result<T>{
    case success(T)
    case failure(Error?)
}

struct DHErrorCodes {
    static let requestInProgress   = 2002
    static let JSONParse           = 2001
    static let noNextPage          = 204
    static let noContent           = 204
    static let noNetWork           = -10000
    static let invalidURL          = 20003
    static let invalidData         = 20004
    static let timeOut             = NSURLErrorTimedOut
}

extension NSError {
    
    class func error(errorCode: Int) -> NSError {
        return NSError(domain: "com.dh.errpr", code: errorCode, userInfo: nil)
    }
    
    func statusCode() -> Int? {
        guard let response = userInfo["com.alamofire.serialization.response.error.response"] as? HTTPURLResponse  else {
            return nil
        }
        return response.statusCode
    }
}

extension Error {
    var isNoContentError: Bool {
        return (self as NSError).code ==  DHErrorCodes.noContent
    }
}

class APIService<R:RequestProtocol, T : APIParser> {
    private let baseUrl : URL
    private let requestParams : [String : AnyObject]?
    private let headers: [String : AnyObject]?

    private var requestMethod : HTTPMethod

    private var isRequestInProgress = false

    init(baseUrl : URL, requestParams : [String : AnyObject]? = nil, headers: [String : AnyObject]? = nil, requestMethod : HTTPMethod = .GET) {
        self.baseUrl = baseUrl
        self.requestParams = requestParams
        self.headers = headers
        self.requestMethod = requestMethod
}
    
    func fetch(completion: @escaping (Result<T>)->Void){
        
        if !isRequestInProgress{
             isRequestInProgress = true
            
        let adapter = R.getInstance()
            adapter.fetchGetRequest(urlString: baseUrl.absoluteString, parameters: requestParams, headers: headers as? [String : String], completion: {[weak self] (result) in
                
                guard let strongSelf = self else{
                    return
                }
                
                switch result{
                case .success(let responseData) :
                    if let responseModel = T.parse(response : responseData){
                        completion(.success(responseModel))
                    }
                    else{
                        completion(.failure(NSError.error(errorCode: DHErrorCodes.JSONParse)))
                    }
                case .failure(let error) :
                if let error = error as NSError?{
                    if error.code == 204 || error.code == 404 {
                        completion(.failure(NSError.error(errorCode: DHErrorCodes.noNextPage)))
                    }
                    else if error.statusCode() == NSURLErrorTimedOut{
                        completion(.failure(NSError.error(errorCode: DHErrorCodes.timeOut)))
                    }
                    else{
                        completion(.failure(error))
                    }
                }
                    
                }
                
                
            })
    }
        else{
            completion(.failure(NSError.error(errorCode: DHErrorCodes.requestInProgress)))
        }
        
    }
}

extension APIParser where Self : CodableAPIParser{
    typealias ModalType = Self
    static func parse(response : Any)->Self? {
        guard let responseData = response as? Data else{
            return nil
        }
        do{
            let aDecoder = JSONDecoder()
            
            let decodedModel = try aDecoder.decode(Self.self, from: responseData)
            return decodedModel
        }
        catch let e{
            print("Error : \(e)")
            return nil
        }
    }
}

extension CodableAPIParser{
    typealias ModalType = Self
}
