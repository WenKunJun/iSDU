//
//  TabTwoViewController.swift
//  iSDU
//
//  Created by Mike：） on 17/2/27.
//  Copyright © 2017年 Micky&Murray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TabTwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

        //校车查询功能实现
        //API：https://online.sdu.edu.cn/Api/schoolbus/index.php?act=1&start=兴隆山校区&end=中心校区&isWeekend=true
    
    func BusCheckout(){
        let isWeekend = false
        let fromPlace = "兴隆山校区"
        let toPlace = "中心校区"
        
        let mUrl = "https://online.sdu.edu.cn/Api/schoolbus/index.php?act=1&start=\(fromPlace))&end=\(toPlace)&isWeekend=\(isWeekend)"
        print("=========>" + mUrl)
        
        Alamofire.request(mUrl, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON{(response:DataResponse<Any>) in
            switch(response.result){
            case .success(_):
                if let data = response.result.value{
                    print("Success :=====> \(response.result.value)")
                    let json = JSON(data)
                    
                    let fromResulr = json[0]["s"].stringValue
                    let toResult = json[0]["e"].stringValue
                    let timeResult = json[0]["t"].stringValue
                    
                    print(fromResulr)
                    print(toResult)
                    print(timeResult)
                }
                break
            case .failure(_):
                print("Failure :======> \(response.result.error)")
                
            }

        }
        
    }
}
