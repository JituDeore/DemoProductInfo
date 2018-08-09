//
//  RequestProtocol.swift
//  Assignment
//
//  Created by Jitendra Deore on 09/08/18.
//  Copyright © 2018 Jitendra Deore. All rights reserved.
//
import Foundation


protocol RequestProtocol {
     func fetchGetRequest(urlString : String, parameters : [String : Any]?, headers : [String : String]?, completion: @escaping (Result<[String : Any]>) -> Void)
    
    static func getInstance() -> RequestProtocol
}

