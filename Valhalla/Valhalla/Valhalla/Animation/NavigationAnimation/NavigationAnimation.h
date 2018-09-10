//
//  NavigationAnimation.h
//  Valhalla
//
//  Created by mademao on 2018/9/10.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    NavigationAnimationTypePush,
    NavigationAnimationTypePop
} NavigationAnimationType;

@interface NavigationAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) NavigationAnimationType navigationAnimationType;

@end
