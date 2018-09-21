//
//  KeychainUtil.m
//  Keychain-OC
//
//  Created by Pluto on 2017/7/3.
//  Copyright © 2017年 Pluto. All rights reserved.
//

#import "KeychainUtil.h"
#import <Security/Security.h>
#import <UIKit/UIKit.h>

@interface KeychainUtil ()
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *serviceName;
@end

@implementation KeychainUtil
///单例保存UUID到内存中
static KeychainUtil *util = nil;
+ (instancetype)standard {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[KeychainUtil alloc] init];
    });
    return util;
}

///设置在钥匙串中Service名
+ (void)setServiceName:(NSString *)serviceName {
    KeychainUtil *util = [KeychainUtil standard];
    util.serviceName = serviceName;
}

///获取思路，1.从内存中获取 2.从钥匙串中获取 3.生成新的并保存至钥匙串
+ (NSString *)getUUID {
    if ([KeychainUtil standard].uuid == nil || [KeychainUtil standard].uuid.length == 0) {
        NSString *uuidStr = (NSString *)[[KeychainUtil standard] select:[[KeychainUtil standard].serviceName stringByAppendingString:@"keychain"]];
        if (uuidStr == nil || uuidStr.length == 0) {
            uuidStr = [[KeychainUtil standard] getUUID];
            [[KeychainUtil standard] save:[[KeychainUtil standard].serviceName stringByAppendingString:@"keychain"] data:uuidStr];
        }
        [KeychainUtil standard].uuid = uuidStr;
    }
    return [KeychainUtil standard].uuid;
}

///从Keychain中删除标识码
+ (void)deleteUUID {
    [[KeychainUtil standard] delete:[[KeychainUtil standard].serviceName stringByAppendingString:@"keychain"]];
}


#pragma mark - 帮助方法
- (NSString *)getUUID {
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
}


#pragma mark - 钥匙串操作
- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    /*
     kSecAttrGeneric  标识符(此属性是可选项，但是为了能获取存取的值更精确，最好还是写上吧)
     kSecClass  是你存数据是什么格式，这里是通用密码格式
     kSecAttrService  存的是什么服务，这个是用来到时候取的时候找到对应的服务存的值（这个属性类似于主键，kSecAttrService、kSecAttrAccount必须要赋一个值）
     kSecAttrAccount  账号，在这里作用与服务没差别（且是否必写与kSecAttrService一样）
     当你有服务或者账号则必须有密码
     kSecAttrAccessible  安全性
     */
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword, (__bridge_transfer id)kSecClass,
            [KeychainUtil standard].serviceName, (__bridge_transfer id)kSecAttrGeneric,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAlways, (__bridge_transfer id)kSecAttrAccessible, nil];
}


#pragma mark - 标识与钥匙串操作
- (void)save:(NSString *)service data:(id)data {
    OSStatus result;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    CFDictionaryRef cKeychainQuery = (__bridge_retained CFDictionaryRef)keychainQuery;
    SecItemDelete(cKeychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    result = SecItemAdd(cKeychainQuery, NULL);
    if (cKeychainQuery) {
        CFRelease(cKeychainQuery);
    }
    NSCAssert(result == noErr, @"Couldn't add the Keychain Item.");
}

- (void)update:(NSString *)service data:(id)data {
    OSStatus result;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    NSMutableDictionary *tempCheck = [self getKeychainQuery:service];
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    result = SecItemUpdate((CFDictionaryRef)keychainQuery, (CFDictionaryRef)tempCheck);
    NSCAssert(result == noErr, @"Couldn't update the Keychain Item.");
}

- (id)select:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", service, exception);
        } @finally {
        }
    } else {
        NSLog(@"Couldn't select the keychain item.");
    }
    return ret;
}

- (void)delete:(NSString *)service {
    OSStatus result;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    CFDictionaryRef cKeychainQuery = (__bridge_retained CFDictionaryRef)keychainQuery;
    result = SecItemDelete(cKeychainQuery);
    if (cKeychainQuery) {
        CFRelease(cKeychainQuery);
    }
    NSCAssert(result == noErr, @"Couldn't delete the keychain item.");
}

@end
