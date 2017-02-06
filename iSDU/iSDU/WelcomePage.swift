//
//  WelcomePage.swift
//  iSDU
//
//  Created by Mike：） on 17/1/31.
//  Copyright © 2017年 Micky&Murray. All rights reserved.
//

import Foundation
import UIKit

public let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
public let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
public let ScreenBounds: CGRect = UIScreen.main.bounds


class WelcomePage: UIViewController {
    
    fileprivate var collectView: UICollectionView?
    fileprivate var imageNames = ["page1", "page2", "page3", "page4"]
    fileprivate let cellIdentifier = "GuideCell"
    fileprivate var isHiddenNextButton = true
    fileprivate var pageController = UIPageControl(frame: CGRect(x: 0, y: ScreenHeight - 50, width: ScreenWidth, height: 20))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildCollectionView()
        buildPageController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Build UI
    fileprivate func buildCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = ScreenBounds.size
        layout.scrollDirection = .horizontal
        
        collectView = UICollectionView(frame: ScreenBounds, collectionViewLayout: layout)
        collectView?.delegate = self
        collectView?.dataSource = self
        collectView?.showsVerticalScrollIndicator = false
        collectView?.showsHorizontalScrollIndicator = false
        collectView?.isPagingEnabled = true
        collectView?.bounces = false
        collectView?.register(GuideCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectView!)
    }
    
    func buildPageController() {
        pageController.numberOfPages = imageNames.count
        pageController.currentPage = 0
        view.addSubview(pageController)
    }
    
    
}


extension WelcomePage: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GuideCell
        cell.newImage = UIImage(named: imageNames[indexPath.row])
        if indexPath.row != imageNames.count - 1{ // 3
            cell.setNextButtonHidden(true) // 如果不是第三张就隐藏button
        }
        func changeView () -> Void {let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            self.present(vc, animated: true, completion: nil)
            
        }
        cell.initWithClosure(closure: changeView)
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == ScreenWidth * CGFloat(imageNames.count - 1) {
            let cell = collectView!.cellForItem(at: NSIndexPath(row: imageNames.count - 1, section: 0) as IndexPath) as! GuideCell
            cell.setNextButtonHidden(false)
            isHiddenNextButton = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != ScreenWidth * CGFloat(imageNames.count - 1) && !isHiddenNextButton && scrollView.contentOffset.x > ScreenWidth * CGFloat(imageNames.count - 2) {
            let cell = collectView!.cellForItem(at: NSIndexPath(row: imageNames.count - 1, section: 0) as IndexPath) as! GuideCell
            cell.setNextButtonHidden(true)
            isHiddenNextButton = true
        }
        pageController.currentPage = Int(scrollView.contentOffset.x / ScreenWidth + 0.5)
    }
}
