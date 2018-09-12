//
//  PointToScreenTranstion.h
//  Valhalla
//
//  Created by mademao on 2018/9/12.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PointToScreenTranstionTypePresent,
    PointToScreenTranstionTypeDismiss
} PointToScreenTranstionType;

static const NSInteger kPointToScreenTranstionViewTag = 13256;

@interface PointToScreenTranstion : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithType:(PointToScreenTranstionType)type;
+ (instancetype)transtionWithType:(PointToScreenTranstionType)type;

@end
