//
//  SaleItemCollectionFooterView.swift
//  Assignment
//
//  Created by Jitendra Deore on 09/08/18.
//  Copyright © 2018 Jitendra Deore. All rights reserved.
//

import UIKit

class SaleItemCollectionFooterView: UICollectionReusableView {
    @IBOutlet weak var refreshControlIndicator: UIActivityIndicatorView!
    
    var isAnimatingFinal:Bool = false
    var currentTransform:CGAffineTransform?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.prepareInitialAnimation()
        //startAnimate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func startAnimate() {
        self.isAnimatingFinal = true
        self.refreshControlIndicator?.startAnimating()
    }
    
    func stopAnimate() {
        self.isAnimatingFinal = false
        self.refreshControlIndicator?.stopAnimating()
    }
    
}
