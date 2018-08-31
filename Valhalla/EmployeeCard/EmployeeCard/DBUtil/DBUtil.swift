//
//  DBUtil.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/3/31.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import Foundation
import FMDB
import Pluto

class DBUtil {
    
    static let sharedDBUtil = DBUtil()
    
    var queue: FMDatabaseQueue?
    init() {
        loadQueue()
        createTable()
    }
    
    //初始化FMDBQueue
    private func loadQueue() -> Void {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        pltLog("📂--->" + documentPath)
        let dbFilePath = documentPath + "/EmployeeCardDataBase.sqlite"
        queue = FMDatabaseQueue.init(path: dbFilePath)
    }
    
    //创建对应的表
    private func createTable() -> Void {
        createVersionInfoTable()
        createEmployeeInfoTable()
        createAddressListTable()
    }
    
    //关闭数据库
    deinit {
        queue?.close()
    }
}

// MARK: - 表版本表相关
extension DBUtil {
    //创建表版本表
    fileprivate func createVersionInfoTable() -> Void {
        let sql = "create table if not exists versioninfo (module text primary key, version text)"
        queue?.inDatabase({ (database) in
            database?.executeStatements(sql)
        })
    }
    
    //根据module获取对应版本，若没有对应的module，则插入版本为0的数据
    func getVersionWith(module: String) -> String {
        var version: String?
        let sql = "select * from versioninfo where module = ?"
        queue?.inDatabase({ (database) in
            let set = try? database?.executeQuery(sql, values: [module])
            if set??.next() == true {
                version = set!!.string(forColumn: "version")
            }
            set??.close()
        })
        if version == nil {
            version = "0.0.0"
            updateVersionWith(module: addressModule, version: version!)
        }
        return version!
    }
    
    //根据module更新对应版本
    func updateVersionWith(module: String, version: String) -> Void {
        let sql = "replace into versioninfo values (?, ?)"
        queue?.inDatabase({ (database) in
            try? database?.executeUpdate(sql, values: [module, version])
        })
    }
}

// MARK: - 缓存用户表相关
extension DBUtil {
    //创建缓存用户表
    fileprivate func createEmployeeInfoTable() -> Void {
        let sql = "create table if not exists employeeinfo (userid text primary key, username text, photo text, phone text, imgstr text)"
        queue?.inDatabase({ (database) in
            database?.executeStatements(sql)
        })
    }
    
    //缓存用户对象
    func saveEmployee(employee: Employee) -> Void {
        saveEmployee(userId: employee.userId, userName: employee.userName, photo: employee.photo, phone: employee.phone, imgStr: employee.imgStr)
    }
    
    //缓存用户信息
    func saveEmployee(userId: String?, userName: String?, photo: String?, phone: String?, imgStr: String?) -> Void {
        let sql = "replace into employeeinfo values (?, ?, ?, ?, ?)"
        queue?.inDatabase({ (database) in
            try? database?.executeUpdate(sql, values: [userId ?? "", userName ?? "", photo ?? "", phone ?? "", imgStr ?? ""])
        })
    }
    
    //根据用户ID获取用户信息
    func getEmployeeWith(id: String) -> Employee? {
        var employee: Employee?
        
        let sql = "select * from employeeinfo where userid = ?"
        queue?.inDatabase({ (database) in
            let set = try? database?.executeQuery(sql, values: [id.uppercased()])
            if set??.next() == true {
                employee = Employee(userId: set??.string(forColumn: "userid"), userName: set??.string(forColumn: "username"), photo: set??.string(forColumn: "photo"), phone: set??.string(forColumn: "phone"), imgStr: set??.string(forColumn: "imgstr"))
                set??.close()
            }
        })
        return employee
    }
}

// MARK: - 职工表相关
extension DBUtil {
    //创建职工表
    fileprivate func createAddressListTable() -> Void {
        let sql = "create table if not exists address_list (id text primary key, name text, gender text, phonenumber text, officephone text, email text, photo text, o text, py text)"
        queue?.inDatabase({ (database) in
            database?.executeStatements(sql)
        })
    }
    
    //查询所有职工
    func selectAllAddress() -> [[String : [AddressModel]]] {
        var array = [[String : [AddressModel]]]()
        let sql = "select * from address_list order by id"
        queue?.inDatabase({ (database) in
            let set = try? database?.executeQuery(sql, values: [])
            var dic = [String : [AddressModel]]()
            while set??.next() == true {
                let id = set??.string(forColumn: "id") ?? ""
                let name = set??.string(forColumn: "name") ?? ""
                let gender = set??.string(forColumn: "gender") ?? ""
                let phonenumber = set??.string(forColumn: "phonenumber") ?? ""
                let officephone = set??.string(forColumn: "officephone") ?? ""
                let email = set??.string(forColumn: "email") ?? ""
                let photo = set??.string(forColumn: "photo") ?? ""
                let o = set??.string(forColumn: "o") ?? ""
                let py = set??.string(forColumn: "py") ?? ""
                
                let group = id.substring(to: id.index(id.startIndex, offsetBy: 1))
               
                if dic.count == 0 {
                    dic = [group : [AddressModel]()]
                }
                if dic.keys.contains(group) == false {
                    array.append(dic)
                    dic = [group : [AddressModel]()]
                }
                dic[group]?.append(AddressModel(id: id, name: name, gender: gender, phonenumber: phonenumber, officephone: officephone, email: email, photo: photo, o: o, py: py))
            }
            set??.close()
        })
        return array
    }
    
    //清空职工表
    func clearAddressListTable() -> Void {
        let sql = "delete from address_list"
        queue?.inDatabase({ (database) in
            database?.executeStatements(sql)
        })
    }
    
    //将数据写入职工表
    func writeToAddressListTable(data: [[String : Any]]) -> Void {
        let sql = "replace into address_list values (?, ?, ?, ?, ?, ?, ?, ?, ?)"
        queue?.inDatabase({ (database) in
            for item in data {
                let id = item["id"] ?? ""
                let name = item["name"] ?? ""
                let gender = item["gender"] ?? ""
                let phonenumber = item["phonenumber"] ?? ""
                let officephone = item["officephone"] ?? ""
                let email = item["email"] ?? ""
                let photo = item["photo"] ?? ""
                let o = item["o"] ?? ""
                let py = item["py"] ?? ""
                try? database?.executeUpdate(sql, values: [id, name, gender, phonenumber, officephone, email, photo, o, py])
            }
        })
    }
    
    //根据ID获取头像url
    func getEmployeePhoto(userId: String) -> String? {
        var photo: String?
        let sql = "select photo from address_list where id = ?"
        queue?.inDatabase({ (database) in
            let set = try? database?.executeQuery(sql, values: [userId.uppercased()])
            if set??.next() == true {
                photo = set??.string(forColumn: "photo")
                set??.close()
            }
        })
        if photo != nil {
            photo = "\(baseUrl)dwCard/images/emp_photos/\(photo!)"
        }
        return photo
    }
}
