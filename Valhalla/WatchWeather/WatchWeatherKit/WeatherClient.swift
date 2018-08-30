//
//  WeatherClient.swift
//  WatchWeatherKit
//
//  Created by Dareway on 2017/11/2.
//  Copyright © 2017年 Pluto. All rights reserved.
//

import Foundation

public let WatchWeatherKitErrorDomain = "com.pluto.WatchWeatherKit.error"
public struct WatchWeatherKitError {
    public static let CorruptedJSON = 1000
}

public struct WeatherClient {
    public static let sharedClient = WeatherClient()
    let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    public func requestWeathers(handler: ((_ weather: [Weather?]?, _ error: NSError?) -> Void)?) -> Void {
        guard let url = URL(string: "https://raw.githubusercontent.com/onevcat/WatchWeather/master/Data/data.json") else {
            handler?(nil, NSError(domain: WatchWeatherKitErrorDomain, code: NSURLErrorBadURL, userInfo: nil))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                handler?(nil, error as NSError?)
            } else {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let dictionary = object as? [String : AnyObject] {
                        handler?(Weather.parseWeatherResult(dictionary: dictionary), nil)
                    }
                } catch _ {
                    handler?(nil, NSError(domain: WatchWeatherKitErrorDomain, code: WatchWeatherKitError.CorruptedJSON, userInfo: nil))
                }
            }
        }
        
        task.resume()
    }
}

