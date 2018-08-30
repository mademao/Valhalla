//
//  Weather.swift
//  WatchWeatherKit
//
//  Created by Dareway on 2017/11/2.
//  Copyright © 2017年 Pluto. All rights reserved.
//

import Foundation

public struct Weather {
    public enum State: Int {
        case Sunny, Cloudy, Rain, Snow
    }
    
    public let state: State
    public let highTemperature: Int
    public let lowTemperature: Int
    public let day: Day
    
    public init?(json: [String : AnyObject]) {
        guard let stateNumber = json["state"] as? Int,
              let state = State(rawValue: stateNumber),
              let highTemperature = json["high_temp"] as? Int,
              let lowTemperature = json["low_temp"] as? Int,
              let dayNumber = json["day"] as? Int,
              let day = Day(rawValue: dayNumber) else {
            return nil
        }
        
        self.state = state
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
        self.day = day
    }
}

// MARK: - Parsing weather request
extension Weather {
    static func parseWeatherResult(dictionary: [String : AnyObject]) -> [Weather?]? {
        if let weathers = dictionary["weathers"] as? [[String : AnyObject]] {
            return weathers.map{ Weather(json: $0) }
        } else {
            return nil
        }
    }
}
