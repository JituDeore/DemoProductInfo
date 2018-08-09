//
//  ProductListingViewModal.swift
//  Assignment
//
//  Created by Jitendra Deore on 09/08/18.
//  Copyright © 2018 Jitendra Deore. All rights reserved.
//

import Foundation
import SDWebImage

class ProductListingViewModal {
    
    var service = ProductListingService()
    var saleItems = [ProductModal](){
        didSet{
            viewController?.itemCollectionView.reloadData()
        }
    }
    
    weak var viewController : ViewController?
    
    init(viewController : ViewController) {
        self.viewController = viewController
    }
    
    func fetch(isRefresh : Bool = false){
        service.fetch(){[weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.viewController?.refreshControl.endRefreshing()
            
            if(isRefresh){
                strongSelf.saleItems = [ProductModal]()
            }
            
            switch(result){
            case .success(let responseData) :
                strongSelf.saleItems = strongSelf.saleItems + responseData.productArray
                
            case .failure(let error) :
                print("Received Error \(String(describing: error))!!!")
                break
            }
        }
    }
    
    func refresh(){
        service = ProductListingService()
        fetch(isRefresh:  true)
    }
    
    func renderData(cell : SaleItemCollectionViewCell, indexpath : IndexPath){
        let item = saleItems[indexpath.row]
        
        cell.itemTitleLabel.text = item.title
        cell.itemPriceLabel.text = "$\(item.price)"
        cell.itemQuatityLabel.text = item.quantityString
        cell.itemImageView.sd_setImage(with: URL(string: item.imageUrl), placeholderImage: UIImage(named: "imagePlaceholder.png"))
    }
    
    func renderData(viewController : DetailViewController, indexpath : IndexPath){
        let item = saleItems[indexpath.row]
        _ = viewController.view
        viewController.titleLabel.text = item.title
        viewController.itemQuantityLabel.text = item.quantityString
        viewController.itemPriceLabel.text = "$\(item.price)"
        viewController.itemProductDescription.text = item.description
        viewController.itemOriginCountryLabel.text = item.originCountry
        viewController.itemCoverImage.sd_setImage(with: URL(string: item.imageUrl), placeholderImage: UIImage(named: "imagePlaceholder.png"))
    }
}
