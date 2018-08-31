//
//  AddressUtil.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/5.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit
import Pluto

let addressModule = "address"
fileprivate var addressQueue = DispatchQueue(label: "cn.com.pluto.addressQueue")

class AddressUtil: NSObject {
    //开辟线程获取最新的通讯录数据
    final class func getAddressFromServer() -> Void {
        addressQueue.async {
            NetUtil.post(url: adlsVersionUrl,
                         param: nil,
                         success: { (data) in
                            if (data as! [String : Any])["errorCode"] as! String == "0" {
                                checkVersion(serverVersion: (data as! [String : Any])["version"] as! String)
                            }
            },
                         failure: { (error) in
                            pltError("获取通讯录版本出错")
            })
        }
    }
    
    //检测是否需要请求新的数据
    fileprivate final class func checkVersion(serverVersion: String) -> Void {
        addressQueue.async {
            let localVersion = DBUtil.sharedDBUtil.getVersionWith(module: addressModule)
            if localVersion < serverVersion {
                NetUtil.post(url: adlsInfoUrl,
                             param: nil,
                             success: { (data) in
                                writeNewData(data: (data as! [String : Any])["adlist"] as! [[String : Any]])
                                DBUtil.sharedDBUtil.updateVersionWith(module: addressModule, version: serverVersion)
                },
                             failure: { (error) in
                                pltError("获取通讯录出错")
                })
            }
        }
    }
    
    //存储新的数据
    fileprivate final class func writeNewData(data: [[String : Any]]) -> Void {
        addressQueue.async {
            DBUtil.sharedDBUtil.writeToAddressListTable(data: data)
            pltRight("完成")
        }
    }
}

