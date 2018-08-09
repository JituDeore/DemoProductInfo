//
//  DetailViewController.swift
//  Assignment
//
//  Created by Jitendra Deore on 09/08/18.
//  Copyright © 2018 Jitendra Deore. All rights reserved.
//

import Foundation
import UIKit

class  DetailViewController: UIViewController {
    
    @IBOutlet weak var itemCoverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemProductDescription: UILabel!
    @IBOutlet weak var itemOriginCountryLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productDescriptionContainer: UIView!
    @IBAction func addToCartAction(_ sender: Any) {
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToCartButton.layer.cornerRadius = 7
        addToCartButton.layer.masksToBounds = true
        productDescriptionContainer.clipsToBounds = true
        productDescriptionContainer.layer.borderColor = UIColor.lightGray.cgColor
        productDescriptionContainer.layer.borderWidth = 0.5
    }
}
