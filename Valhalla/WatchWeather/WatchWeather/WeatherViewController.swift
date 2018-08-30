//
//  WeatherViewController.swift
//  WatchWeather
//
//  Created by Dareway on 2017/11/2.
//  Copyright © 2017年 Pluto. All rights reserved.
//

import UIKit
import WatchWeatherKit

class WeatherViewController: UIViewController {
    
    var weather: Weather? {
        didSet {
            title = weather?.day.title
        }
    }
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lowLabel.text = "\(weather!.lowTemperature)℃"
        heightLabel.text = "\(weather!.highTemperature)℃"
        
        let imageName: String
        switch weather!.state {
        case .Sunny: imageName = "sunny"
        case .Cloudy: imageName = "cloudy"
        case .Rain: imageName = "rain"
        case .Snow: imageName = "snow"
        }
        
        weatherImageView.image = UIImage(named: imageName)
    }
    
}
