//
//  TabOneViewController.swift
//  iSDU
//
//  Created by Mike：） on 17/2/8.
//  Copyright © 2017年 Micky&Murray. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class TabOneViewController: UIViewController , CLLocationManagerDelegate{
    
    let LocationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Do any additional setup after loading the view, typically from a nib.
        LocationManager.requestAlwaysAuthorization()
        LocationManager.startUpdatingLocation()
        updateWeatherInfo(latitude: (LocationManager.location?.coordinate.latitude)!, longitude: (LocationManager.location?.coordinate.longitude)!)
    }
    
    //实现satrtUpdatingLocation() 的回调
    //location 改变时回调
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location : CLLocation = locations[locations.count-1] as CLLocation
        
        if location.horizontalAccuracy > 0{
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            self.updateWeatherInfo(latitude:location.coordinate.latitude,longitude: location.coordinate.longitude)
            LocationManager.stopUpdatingLocation()
        }
    }
    
    //更新天气信息
    func updateWeatherInfo(latitude:CLLocationDegrees,longitude:CLLocationDegrees) {
        let mParams = ["lat":latitude,"lon":longitude]
        let mUrl = "https://api.thinkpage.cn/v3/weather/now.json?key=hqz8lpvqz0tjvcvf&location=\(latitude):\(longitude)&language=zh-Hans&unit=c"
        
        print(mUrl)
        
        Alamofire.request(mUrl, method: .get, parameters: mParams, encoding: URLEncoding.default, headers: nil).responseJSON{(response:DataResponse<Any>) in
            switch(response.result){
            case .success(_):
                //                self.progressbar.stopAnimating()
                //                self.progressbar.isHidden = true
                if let data = response.result.value{
                    print("Success :=====> \(response.result.value)")
                    let json = JSON(data)
                    
                    let mCityName = json["results"][0]["location"]["name"].stringValue
                    let mTemp = json["results"][0]["now"]["temperature"].stringValue
                    let mDisc = json["results"][0]["now"]["text"].stringValue
                    
                    print(mCityName)
                    print(mTemp + "°C")
                    print(mDisc)
                }
                break
            case .failure(_):
                print("Failure :======> \(response.result.error)")
                
            }
        }
        
    }
    
    
    //错误消息的回调函数
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
