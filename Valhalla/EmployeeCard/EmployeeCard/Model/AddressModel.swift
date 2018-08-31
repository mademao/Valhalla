//
//  AddressModel.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/6.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import Foundation

class AddressModel {
    let id: String
    let name: String
    let gender: String
    let phonenumber: String
    let officephone: String
    let email: String
    let photo: String
    let o: String
    let py: String
    
    init(id: String, name: String, gender: String, phonenumber: String, officephone: String, email: String, photo: String, o: String, py: String) {
        self.id = id
        self.name = name
        self.gender = gender
        self.phonenumber = phonenumber
        self.officephone = officephone
        self.email = email
        self.photo = photo
        self.o = o
        self.py = py
    }
}
