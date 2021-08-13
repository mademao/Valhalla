//
//  KbdConfig.m
//  Keyboard
//
//  Created by mademao on 2021/7/29.
//  Copyright © 2021 mademao. All rights reserved.
//

#import "KbdConfig.h"

@interface KbdConfig ()

@property (nonatomic, assign) BOOL hasFullAccess;

@end

@implementation KbdConfig

+ (instancetype)sharedInstance {
    static KbdConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[KbdConfig alloc] init];
    });
    return config;
}

@end
