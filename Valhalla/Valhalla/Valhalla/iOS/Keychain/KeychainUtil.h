//
//  KeychainUtil.h
//  Keychain-OC
//
//  Created by Pluto on 2017/7/3.
//  Copyright © 2017年 Pluto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainUtil : NSObject

///设置在钥匙串中Service名
+ (void)setServiceName:(NSString *)serviceName;

///获取思路，1.从内存中获取 2.从钥匙串中获取 3.生成新的并保存至钥匙串
+ (NSString *)getUUID;

///从Keychain中删除标识码
+ (void)deleteUUID;

@end
