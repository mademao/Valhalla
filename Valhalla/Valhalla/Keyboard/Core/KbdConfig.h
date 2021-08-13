//
//  KbdConfig.h
//  Keyboard
//
//  Created by mademao on 2021/7/29.
//  Copyright © 2021 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KbdConfig : NSObject

@property (nonatomic, assign, readonly) BOOL hasFullAccess;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
