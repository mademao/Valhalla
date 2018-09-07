//
//  TurnAroundButton.m
//  Animation
//
//  Created by 马德茂 on 16/9/2.
//  Copyright © 2016年 MDM. All rights reserved.
//

#import "TurnAroundButton.h"
#define PMLBTARGET @"PMLBTARGET"
#define PMLBACTION @"PMLBACTION"
#define PMLBEVENT @"PMLBEVENT"

@interface TurnAroundButton ()

/**
 *  背景渲染层
 */
@property (nonatomic, strong) CAShapeLayer *backLayer;

/**
 *  点击背景渲染层
 */
@property (nonatomic, strong) CAShapeLayer *clickLayer;

/**
 *  菊花背景渲染层
 */
@property (nonatomic, strong) CAShapeLayer *loadingLayer;

/**
 *  按钮
 */
@property (nonatomic, strong) UIButton *button;

/**
 *  targetAction保存数组
 */
@property (nonatomic, strong) NSMutableArray *targetActionArray;

@end

@implementation TurnAroundButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initDefaultSetting];
        
        [self addSubviewAndSubLayer];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    NSDictionary *dic = @{PMLBTARGET : target,
                          PMLBACTION : NSStringFromSelector(action),
                          PMLBEVENT  : @(controlEvents)};
    [self.targetActionArray addObject:dic];
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)resetStatus
{
    [self stopAnimation];
    [self.backLayer removeFromSuperlayer];
    [self addSubviewAndSubLayer];
}

- (void)stopAnimation
{
    [self removeAllViewAndLayer];
}

// 初始化属性设置
- (void)initDefaultSetting
{
    self.duration = 1.5;
    self.backColor = [UIColor blueColor];
    self.clickColor = [UIColor grayColor];
    self.title = @"login";
    self.titleFont = [UIFont systemFontOfSize:17];
    self.titleColor = [UIColor whiteColor];
}

// 添加渲染层和view
- (void)addSubviewAndSubLayer
{
    self.backLayer = [self drawBackLayer];
    self.clickLayer = [self drawClickLayer];
    self.button = [self loadButton];
    
    [self.layer addSublayer:self.backLayer];
    [self.layer addSublayer:self.clickLayer];
    [self addSubview:self.button];
}

// 绘制背景渲染层
- (CAShapeLayer *)drawBackLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = [self drawBezierPathWithX:CGRectGetHeight(self.frame) / 2.].CGPath;
    layer.fillColor = self.backColor.CGColor;
    return layer;
}

// 绘制点击背景渲染层
- (CAShapeLayer *)drawClickLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.opacity = 0;
    layer.frame = self.bounds;
    layer.path = [self drawBezierPathWithX:CGRectGetWidth(self.frame) / 2.].CGPath;
    return layer;
}

// 绘制菊花
- (CAShapeLayer *)drawLoadingLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
    layer.position = CGPointMake(CGRectGetWidth(self.frame) / 2., CGRectGetHeight(self.frame) / 2.);
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = 2.;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(25, 25) radius:CGRectGetHeight(self.frame) / 2. - 3 startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    layer.path = bezierPath.CGPath;
    return layer;
}

// 建立点击按钮
- (UIButton *)loadButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.bounds;
    [button setTitle:self.title forState:UIControlStateNormal];
    button.titleLabel.font = self.titleFont;
    [button setTitleColor:self.titleColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    for (NSDictionary *dic in self.targetActionArray) {
        id target = dic[PMLBTARGET];
        SEL action = NSSelectorFromString(dic[PMLBACTION]);
        UIControlEvents events = [dic[PMLBEVENT] integerValue];
        [button addTarget:target action:action forControlEvents:events];
    }
    return button;
}

// 按钮事件
- (void)buttonAction:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    [self clickLayerAnimation];
}

// 点击背景出现并铺满按钮
- (void)clickLayerAnimation
{
    self.clickLayer.opacity = 0.5;
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.19 * self.duration;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawBezierPathWithX:CGRectGetHeight(self.frame) / 2.].CGPath);
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeIn"];
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.clickLayer addAnimation:basicAnimation forKey:@"clickLayerAnimation"];
    
    [self performSelector:@selector(dismissAnimation) withObject:self afterDelay:basicAnimation.duration + 0.075 * self.duration];
}

// 去除按钮并缩短控件
- (void)dismissAnimation
{
    [self removeAllViewAndLayer];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.3 * self.duration;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawBezierPathWithX:CGRectGetWidth(self.frame) / 2.].CGPath);
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeIn"];
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.backLayer addAnimation:basicAnimation forKey:@"dismissAnimation"];
    
    [self performSelector:@selector(loadAnimation) withObject:self afterDelay:basicAnimation.duration + 0.0375 * self.duration];
}

// 菊花
- (void)loadAnimation
{
    self.loadingLayer = [self drawLoadingLayer];
    [self.layer addSublayer:self.loadingLayer];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(M_PI * 2);
    basicAnimation.duration = 0.3975 * self.duration;
    basicAnimation.repeatCount = LONG_MAX;
    [self.loadingLayer addAnimation:basicAnimation forKey:@"loadAnimation"];
}

// 去除所有除了背景渲染层之外的view和layer
- (void)removeAllViewAndLayer
{
    [self.button removeFromSuperview];
    [self.clickLayer removeFromSuperlayer];
    [self.loadingLayer removeFromSuperlayer];
}

// 绘制两边为圆弧的高度为控件高度的长条
- (UIBezierPath *)drawBezierPathWithX:(CGFloat)x
{
    CGFloat radius = self.frame.size.height / 2.;
    CGFloat left = x;
    CGFloat right = self.frame.size.width - x;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    [bezierPath addArcWithCenter:CGPointMake(left, CGRectGetHeight(self.frame) / 2.) radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:NO];
    [bezierPath addArcWithCenter:CGPointMake(right, CGRectGetHeight(self.frame) / 2.) radius:radius startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:NO];
    [bezierPath closePath];
    return bezierPath;
}


- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    self.backLayer.fillColor = backColor.CGColor;
}

- (void)setClickColor:(UIColor *)clickColor
{
    _clickColor = clickColor;
    self.clickLayer.fillColor = clickColor.CGColor;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.button.titleLabel.font = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self.button setTitleColor:titleColor forState:UIControlStateNormal];
}

- (NSMutableArray *)targetActionArray
{
    if (!_targetActionArray) {
        self.targetActionArray = [NSMutableArray array];
    }
    return _targetActionArray;
}
@end
