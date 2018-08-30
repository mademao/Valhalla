//
//  ViewController.swift
//  WatchWeather
//
//  Created by Dareway on 2017/11/2.
//  Copyright © 2017年 Pluto. All rights reserved.
//

import UIKit
import WatchWeatherKit

class ViewController: UIPageViewController {
    
    var data = [Day : Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        WeatherClient.sharedClient.requestWeathers { (weather, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if error == nil && weather != nil {
                    for w in weather! where w != nil {
                        self.data[w!.day] = w
                    }
                    
                    let vc = self.weatherViewController(forDay: .Today)
                    self.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: error?.description ?? "Unknown Error", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func weatherViewController(forDay day: Day) -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        let nav = UINavigationController(rootViewController: vc)
        vc.weather = data[day]
        
        return nav
    }
    
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let nav = viewController as? UINavigationController, let rootVC = nav.viewControllers.first as? WeatherViewController, let day = rootVC.weather?.day else {
            return nil
        }
        
        if day == .DayBeforeYesterday {
            return nil
        }
        
        guard let earlierDay = Day(rawValue: day.rawValue - 1) else {
            return nil
        }
        
        return weatherViewController(forDay: earlierDay)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let nav = viewController as? UINavigationController, let rootVC = nav.viewControllers.first as? WeatherViewController, let day = rootVC.weather?.day else {
            return nil
        }
        
        if day == .DayAfterTomorrow {
            return nil
        }
        
        guard let laterDay = Day(rawValue: day.rawValue + 1) else {
            return nil
        }
        
        return weatherViewController(forDay: laterDay)
    }
}

