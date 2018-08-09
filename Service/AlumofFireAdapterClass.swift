//
//  AlumofFireAdapterClass.swift
//  Assignment
//
//  Created by Jitendra Deore on 09/08/18.
//  Copyright © 2018 Jitendra Deore. All rights reserved.
//

import Foundation
import Alamofire

class AlumofFireAdapterClass : RequestProtocol{

    func fetchGetRequest(urlString : String, parameters : [String : Any]?, headers : [String : String]?, completion: @escaping (Result<[String : Any]>) -> Void) {
        Alamofire.request(urlString,
                          parameters: parameters,
                          headers: headers).responseJSON(completionHandler: { response in
                            if let data = response.data ,
                                let dataString = String(data: data, encoding: String.Encoding.utf8),
                                let dictionary = response.value as? [String : Any]{
                                print(dataString)
                                completion(.success(dictionary))
                            }
                            
                          })
    }
    
    
    static func getInstance() -> RequestProtocol {
        return AlumofFireAdapterClass()
    }

}
