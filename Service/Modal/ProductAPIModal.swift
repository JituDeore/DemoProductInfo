//
//  ProductAPIModal.swift
//  Assignment
//
//  Created by Jitendra Deore on 09/08/18.
//  Copyright © 2018 Jitendra Deore. All rights reserved.
//

import Foundation

struct ProductAPIModal : APIParser{
    typealias ModalType = ProductAPIModal
    var productArray : [ProductModal]
    static func parse(response : Any) -> ModalType?{
        guard let responseDictionary = response as? [String : Any],
        let productDictionary = responseDictionary["products"] as? [[String : Any]] else{
            return nil
        }
        let productArray = productDictionary.map({ProductModal(dictionary : $0)}).flatMap({$0})
        return ProductAPIModal(productArray: productArray)
    }
}

struct ProductModal {
    let title : String
    let description : String
    let price : Float
    let quantityString : String
    let iconUrl : String
    let originCountry : String
    
    var imageUrl : String {
        let baseUrl = "http://media.redmart.com/newmedia/200p"
        return baseUrl + iconUrl
    }
    
    
    init?(dictionary : [String : Any]) {
        
        guard let title = dictionary["title"] as? String,
        let description = dictionary["desc"] as? String,
        let pricingDictionary = dictionary["pricing"] as? [String : Any],
        let price = pricingDictionary["price"] as? Float,
        let measureDictionary = dictionary["measure"] as? [String : Any],
        let quantityString = measureDictionary["wt_or_vol"] as? String,
        let imageArray = dictionary["images"] as? [[String : Any]],
        let firstImage = imageArray.first,
        let iconUrl = firstImage["name"] as? String,
        let detailsDictionary = dictionary["details"] as? [String : Any],
        let countryOfOrigin = detailsDictionary["country_of_origin"] as? String else{
            return nil
        }
        
        self.title = title
        self.description = description
        self.price = price
        self.quantityString = quantityString
        self.iconUrl = iconUrl
        self.originCountry = countryOfOrigin
        
    }
}
