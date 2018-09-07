//
//  TurnAroundButton.h
//  Animation
//
//  Created by 马德茂 on 16/9/2.
//  Copyright © 2016年 MDM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TurnAroundButton : UIView

/**
 *  动画总时间，默认1.5
 */
@property (nonatomic, assign) NSTimeInterval duration;

/**
 *  按钮背景色，默认蓝色
 */
@property (nonatomic, strong) UIColor *backColor;

/**
 *  点击背景色，默认灰色
 */
@property (nonatomic, strong) UIColor *clickColor;

/**
 *  按钮文字，默认login
 */
@property (nonatomic, copy) NSString *title;

/**
 *  按钮文字字体，默认系统17号
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  按钮文字颜色，默认白色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  为按钮添加事件
 */
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/**
 *  重置按钮初始状态
 */
- (void)resetStatus;

/**
 *  停止动画
 */
- (void)stopAnimation;

@end
