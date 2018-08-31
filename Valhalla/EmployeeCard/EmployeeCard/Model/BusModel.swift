//
//  BusModel.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/7.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import Foundation

class BusModel {
    let id: String
    let name: String
    let number: String
    let startTime: String
    let endTime: String
    
    init(id: String?, name: String?, number: String?, startTime: String?, endTime: String?) {
        self.id = id ?? ""
        self.name = name ?? ""
        self.number = number ?? ""
        self.startTime = startTime ?? ""
        self.endTime = endTime ?? ""
    }
}
