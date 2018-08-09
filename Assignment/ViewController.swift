//
//  ViewController.swift
//  Assignment
//
//  Created by Jitendra Deore on 09/08/18.
//  Copyright © 2018 Jitendra Deore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    lazy var refreshControl: UIRefreshControl = { [unowned self] in
        let _refreshControl = UIRefreshControl()
        _refreshControl.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
        return _refreshControl
        }()
    
    var viewModal : ProductListingViewModal!
    let transition = TransitionAnimator()
    
    var selectedCell : SaleItemCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModal = ProductListingViewModal(viewController: self)
        itemCollectionView.contentInset.top = 20
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.refreshControl = refreshControl
//        itemCollectionView.register(SaleItemCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "saleItemCollectionFooterView")
      //  UINib.init(nibName: <#T##String#>, bundle: <#T##Bundle?#>)
     //   itemCollectionView.register(UINib(nibName : "SaleItemCollectionFooterView", bundle : nil), forCellWithReuseIdentifier: "saleItemCollectionFooterView")
        
        itemCollectionView.register(UINib(nibName : "SaleItemCollectionFooterView", bundle : nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "saleItemCollectionFooterView")
        transition.dismissCompletion = {
            self.selectedCell?.isHidden = false
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModal.saleItems.count == 0 {
            refreshControl.beginRefreshing()
            viewModal.fetch()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func startRefreshing(){
        viewModal.refresh()
    }


}

extension ViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if indexPath.row > viewModal.saleItems.count - 9{
            viewModal.fetch()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            let footerView = view as! SaleItemCollectionFooterView
        print("Reached End")
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
//        if elementKind == UICollectionElementKindSectionFooter {
//            let footerView = view as! SaleItemCollectionFooterView
//            footerView.stopAnimate()
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as! SaleItemCollectionViewCell
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        viewController.transitioningDelegate = self
        viewModal.renderData(viewController: viewController, indexpath: indexPath)
        present(viewController, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let selectedCell = selectedCell,
            let originFrame = selectedCell.superview?.convert(selectedCell.frame, to: nil) else {
            return transition
        }
        transition.originFrame = originFrame
        transition.presenting = true
        selectedCell.isHidden = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let orientation = UIApplication.shared.statusBarOrientation
        let collectionViewMargin : CGFloat = 12
        let screenWidth = self.view.frame.size.width - collectionViewMargin
        
        if (orientation == UIInterfaceOrientation.portrait || orientation == UIInterfaceOrientation.portraitUpsideDown){
            return CGSize(width: screenWidth/3 - 4, height: 310)
        }
        return CGSize(width: screenWidth/3 - 1, height: screenWidth/3 - 1)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModal.saleItems.count > 0{
            let collectionViewMargin : CGFloat = 12
            let screenWidth = self.view.frame.size.width - collectionViewMargin
            return CGSize(width: screenWidth, height: 50)
        }
        
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
}

extension ViewController : UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return viewModal.saleItems.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cellIdentifier = "saleItemCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SaleItemCollectionViewCell
        viewModal.renderData(cell: cell, indexpath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "saleItemCollectionFooterView", for: indexPath) as! SaleItemCollectionFooterView
            view.layoutIfNeeded()
            view.startAnimate()
            return view
        }
        return UICollectionReusableView()
        
    }
    
}

