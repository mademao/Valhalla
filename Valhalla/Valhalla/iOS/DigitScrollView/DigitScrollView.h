//
//  DigitScrollView.h
//  DigitScrollViewExample
//
//  Created by 马德茂 on 16/8/26.
//  Copyright © 2016年 MDM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DigitSVDirectionUpward = 0,
    DigitSVDirectionDownward = 1,
} DigitSVDirection;

@interface DigitScrollView : UIView

/**
 *  需要显示的数字，默认0
 */
@property (nonatomic, strong) NSNumber *digit;

/**
 *  数字颜色，默认黑色
 */
@property (nonatomic, strong) UIColor *digitColor;

/**
 *  数字字体，默认系统17号
 */
@property (nonatomic, strong) UIFont *digitFont;

/**
 *  数字宽度，默认控件宽度减去间隔，若设置过大，会被挤压
 */
@property (nonatomic, assign) CGFloat digitWidth;

/**
 * 数字高度，默认控件高度
 */
@property (nonatomic, assign) CGFloat digitHeight;

/**
 *  数字背景颜色，默认白色
 */
@property (nonatomic, strong) UIColor *digitBackgroundColor;

/**
 *  数字背景切弧，默认0
 */
@property (nonatomic, assign) CGFloat digitBackgroundCornerRadius;

/**
 *  间隔宽度，默认0
 */
@property (nonatomic, assign) CGFloat spaceWidth;

/**
 *  间隔颜色，默认白色
 */
@property (nonatomic, strong) UIColor *spaceColor;

/**
 *  动画时间，默认1.5s
 */
@property (nonatomic, assign) CFTimeInterval duration;

/**
 *  每个数字动画延迟时间，默认0.2s
 */
@property (nonatomic, assign) CFTimeInterval durationOffset;

/**
 *  数字滚动长度，默认5
 */
@property (nonatomic, assign) NSUInteger density;

/**
 *  升降序滚动，默认升序
 */
@property (nonatomic, assign) BOOL isAscending;

/**
 *  滚动方向，默认向上
 */
@property (nonatomic, assign) DigitSVDirection direction;

/**
 *  开始加载
 */
- (void)startLoadWithAnimation:(BOOL)animation;

/**
 *  结束动画
 */
- (void)stopAnimation;
@end
