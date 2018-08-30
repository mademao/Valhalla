//
//  InterfaceController.swift
//  WatchWeather WatchKit Extension
//
//  Created by Dareway on 2017/11/2.
//  Copyright © 2017年 Pluto. All rights reserved.
//

import WatchKit
import Foundation
import WatchWeatherWatchKit


class InterfaceController: WKInterfaceController {

    static var index = Day.DayBeforeYesterday.rawValue
    static var controllers = [Day : InterfaceController]()
    
    static var token: Bool = false
    
    @IBOutlet var weatherImageView: WKInterfaceImage!
    @IBOutlet var highLabel: WKInterfaceLabel!
    @IBOutlet var lowLabel: WKInterfaceLabel!
    
    var weather: Weather? {
        didSet {
            if let w = weather {
                updateWeather(w)
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let day = Day(rawValue: InterfaceController.index) else {
            return
        }
        
        InterfaceController.controllers[day] = self
        InterfaceController.index = InterfaceController.index + 1
        if day == .Today {
            becomeCurrentPage()
        }
        
        doToken()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if let w = weather {
            updateWeather(w)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func doToken() -> Void {
        guard InterfaceController.token == false else {
            return
        }
        InterfaceController.token = true
        
        request()
    }
    
    func request() -> Void {
        WeatherClient.sharedClient.requestWeathers { [weak self] (weathers, error) in
            if let weathers = weathers {
                for weather in weathers where weather != nil {
                    guard let controller = InterfaceController.controllers[weather!.day] else {
                        continue
                    }
                    controller.weather = weather
                }
            } else {
                let action = WKAlertAction(title: "Retry", style: .default, handler: {
                    self?.request()
                })
                let errorMessage = (error != nil) ? error!.description : "Unknow Error"
                self?.presentAlert(withTitle: "Error", message: errorMessage, preferredStyle: .alert, actions: [action])
            }
        }
    }
    
    func updateWeather(_ weather: Weather) -> Void {
        lowLabel.setText("\(weather.lowTemperature)℃")
        highLabel.setText("\(weather.highTemperature)℃")
        
        let imageName: String
        switch weather.state {
        case .Sunny: imageName = "sunny"
        case .Cloudy: imageName = "cloudy"
        case .Rain: imageName = "rain"
        case .Snow: imageName = "snow"
        }
        
        weatherImageView.setImageNamed(imageName)
    }

}
