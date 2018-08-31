//
//  Employee.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/3/31.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit

class Employee: NSObject {
    var userId: String?
    var userName: String?
    var photo: String?
    var phone: String?
    var imgStr: String?
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    init(userId: String?, userName: String?, photo: String?, phone: String?, imgStr: String?) {
        self.userId = userId
        self.userName = userName
        self.photo = photo
        self.phone = phone
        self.imgStr = imgStr
    }
}
