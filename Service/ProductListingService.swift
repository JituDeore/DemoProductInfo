//
//  ProductListingService.swift
//  Assignment
//
//  Created by Jitendra Deore on 09/08/18.
//  Copyright © 2018 Jitendra Deore. All rights reserved.
//

import Foundation


class ProductListingService{
    
    var url = "https://api.redmart.com/v1.6.0/catalog/search?theme=all-sales&pageSize=30"
    var pageNum = 0
    var hasNextPage = true
    var service : APIService<AlumofFireAdapterClass,ProductAPIModal>!
    
    init() {
    }
    
    func fetch(completion : @escaping (Result<ProductAPIModal>)->Void){
        
        url = "https://api.redmart.com/v1.6.0/catalog/search?theme=all-sales&pageSize=30&page=\(pageNum)"
        service = APIService(baseUrl:  URL(string : url)!, requestParams: nil, headers: nil, requestMethod: .GET)
        
        service.fetch(){[weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result{
                case .success(let responseData) :
                    strongSelf.pageNum = strongSelf.pageNum + 1
                    completion(.success(responseData))
                
            case .failure(let error) :
                if let error = error as NSError?{
                    if error.statusCode() == DHErrorCodes.noNextPage {
                        self?.hasNextPage = false
                    }
                }
                completion(.failure(error))
                
        }
    }
}
    
}
