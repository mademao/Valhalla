//
//  ConfigModel.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/6.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import Foundation

class ConfigModel {
    let text: String
    let segue: String
    let icon: String
    
    init(text: String, segue: String, icon: String) {
        self.text = text
        self.segue = segue
        self.icon = icon
    }
}
