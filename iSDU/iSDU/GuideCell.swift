//
//  GuideCell.swift
//  iSDU
//
//  Created by Mike：） on 17/1/31.
//  Copyright © 2017年 Micky&Murray. All rights reserved.
//

import Foundation
import UIKit

// 点击Guide页的button
public let GuideViewControllerDidFinish = "GuideViewControllerDidFinish"

class GuideCell: UICollectionViewCell {
    fileprivate let newImageView = UIImageView(frame: ScreenBounds)
    fileprivate let nextButton = UIButton(frame: CGRect(x: (ScreenWidth - 100) * 0.5, y: ScreenHeight - 110, width: 100, height: 33))
    
    var newImage: UIImage? {
        didSet {
            newImageView.image = newImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        newImageView.contentMode = .scaleAspectFill
        contentView.addSubview(newImageView)
        
        nextButton.setBackgroundImage(UIImage(named: "NextButton"), for: UIControlState.normal)
        nextButton.addTarget(self, action: #selector(GuideCell.nextButtonClick), for: UIControlEvents.touchUpInside)
        nextButton.isHidden = true
        contentView.addSubview(nextButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNextButtonHidden(_ hidden: Bool) {
        nextButton.isHidden = hidden
    }
    
    // GuideViewControllerDidFinish 还有一处在app.delegate中 进入到主界面中使用的
    func nextButtonClick() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: GuideViewControllerDidFinish), object: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            _ = storyboard.instantiateViewController(withIdentifier: "mainVC")
        
    }
}
