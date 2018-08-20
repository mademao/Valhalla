//
//  KeychainUtil.swift
//  Keychain-Swift
//
//  Created by Dareway on 2017/7/3.
//  Copyright © 2017年 Pluto. All rights reserved.
//

import UIKit
import Security

let key_in_keychain = "cn.com.Pluto.keychain"

class KeychainUtil: NSObject {
    
    static let util = KeychainUtil()
    var uuid: String?

    ///获取思路，1.从内存中获取 2.从钥匙串中获取 3.生成新的并保存至钥匙串
    class func getUUID() -> String? {
        if util.uuid == nil || util.uuid!.count == 0 {
            var uuidStr = util.select(service: key_in_keychain) as? String
            if uuidStr == nil || uuidStr?.count == 0 {
                uuidStr = util.getUUID()
                util.save(service: key_in_keychain, data: uuidStr!)
            }
            util.uuid = uuidStr
        }
        return util.uuid
    }
    
    ///从Keychain中删除标识码
    class func deleteUUID() {
        util.delete(service: key_in_keychain)
    }
    
}

//MARK: 帮助方法
extension KeychainUtil {
    func getUUID() -> String {
        let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return identifierForVendor
    }
}

//MARK: 钥匙串操作
extension KeychainUtil {
    func getKeychainQuery(service: String) -> Dictionary<NSObject, Any> {
        return [kSecClass : kSecClassGenericPassword,
                kSecAttrGeneric : "cn.com.Pluto",
                kSecAttrService : service,
                kSecAttrAccount : service,
                kSecAttrAccessible : kSecAttrAccessibleAlways]
    }
}


//MARK: 标识与钥匙串操作
extension KeychainUtil {
    func save(service: String, data: Any) -> Void {
        var result: OSStatus?
        var keychainQuery = getKeychainQuery(service: service)
        SecItemDelete(keychainQuery as CFDictionary)
        keychainQuery[kSecValueData] = NSKeyedArchiver.archivedData(withRootObject: data)
        result = SecItemAdd(keychainQuery as CFDictionary, nil)
        assert(result == noErr, "Couldn't add the Keychain Item.")
    }
    
    func update(service: String, data: Any) -> Void {
        var result: OSStatus?
        var keychainQuery = getKeychainQuery(service: service)
        let tempCheck = getKeychainQuery(service: service)
        keychainQuery[kSecValueData] = NSKeyedArchiver.archivedData(withRootObject: data)
        result = SecItemUpdate(keychainQuery as CFDictionary, tempCheck as CFDictionary)
        assert(result == noErr, "Couldn't update the keychain Item.")
    }
    
    func select(service: String) -> Any? {
        var ret: Any?
        var keychainQuery = getKeychainQuery(service: service)
        keychainQuery[kSecReturnData] = kCFBooleanTrue
        keychainQuery[kSecMatchLimit] = kSecMatchLimitOne
        var keyData: AnyObject?
        if SecItemCopyMatching(keychainQuery as CFDictionary, &keyData) == noErr {
            ret = NSKeyedUnarchiver.unarchiveObject(with: keyData as! Data)
        }
        return ret
    }
    
    func delete(service: String) -> Void {
        var result: OSStatus?
        let keychainQuery = getKeychainQuery(service: service)
        result = SecItemDelete(keychainQuery as CFDictionary)
        assert(result == noErr, "Couldn't delete the keychain item.")
    }
}
