//
//  WeddingModel.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/7.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import Foundation

class WeddingModel {
    let mid: String
    let mdepart: String
    let mname: String
    let wname: String
    let shortdate: String
    let lxr: String
    let email: String
    let marrydate: String
    let hotel: String
    let photo: String
    let type: String
    
    init(mid: String?, mdepart: String?, mname: String?, wname: String?, shortdate: String?, lxr: String?, email: String?, marrydate: String?, hotel: String?, photo: String?, type: String?) {
        self.mid = mid ?? ""
        self.mdepart = mdepart ?? ""
        self.mname = mname ?? ""
        self.wname = wname ?? ""
        self.shortdate = shortdate ?? ""
        self.lxr = lxr ?? ""
        self.email = email ?? ""
        self.marrydate = marrydate ?? ""
        self.hotel = hotel ?? ""
        self.photo = photo ?? ""
        self.type = type ?? ""
    }
}
