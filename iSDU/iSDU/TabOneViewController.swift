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
    
    //星期菜单栏
    private var menuView: CVCalendarMenuView!
    
    //日历主视图
    private var calendarView: CVCalendarView!
    
    var currentCalendar: Calendar!
    
    @IBOutlet weak var previousView: UIView!
    @IBOutlet weak var nextView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.requestAlwaysAuthorization()
        LocationManager.startUpdatingLocation()
//        updateWeatherInfo(latitude: (LocationManager.location?.coordinate.latitude)!, longitude: (LocationManager.location?.coordinate.longitude)!)
        
        //Calendar
        currentCalendar = Calendar.init(identifier: .gregorian)
        
        self.menuView = CVCalendarMenuView(frame: CGRect(x: 0, y: 80 , width: self.view.bounds.width, height: 15))
        self.calendarView = CVCalendarView(frame: CGRect(x:0 , y: 110, width:self.view.bounds.width , height: 30))
        
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
        
        self.view.addSubview(menuView)
        self.view.addSubview(calendarView)
        
        nextView.isUserInteractionEnabled = true
        previousView.isUserInteractionEnabled = true
        
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
//        let mUrl = "https://api.thinkpage.cn/v3/weather/now.json?key=hqz8lpvqz0tjvcvf&location=\(latitude):\(longitude)&language=zh-Hans&unit=c"
       
        let mUrl = "https://api.thinkpage.cn/v3/weather/now.json?key=hqz8lpvqz0tjvcvf&location=\(latitude):\(longitude)&language=zh-Hans&unit=c"
        
        print(mUrl)
        print("\(latitude):\(longitude)")
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //更新日历frame
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    //MARK: Calendar Delegate
    
    
    @IBAction func loadPrevious(_ sender: UITapGestureRecognizer) {
        calendarView.loadPreviousView()
    }
    
    @IBAction func loadNext(_ sender: UITapGestureRecognizer) {
        calendarView.loadNextView()
    }
    
    @IBAction func Today(_ sender: UIBarButtonItem) {
        let today = Date()
        self.calendarView.toggleViewWithDate(today)
        self.calendarView.toggleCurrentDayView()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//Calendar
extension TabOneViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func presentationMode() -> CalendarMode {
        return .weekView
    }
    
    //每周的第一天
    func firstWeekday() -> Weekday {
        //从星期一开始
        return .monday
    }
    
    
    //每个日期上面是否添加横线(连在一起就形成每行的分隔线)
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    //切换周的时候日历是否自动选择某一天（本周为今天，其它周为第一天）
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return true
    }
    
    //是否显示非当月的日期
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
}
