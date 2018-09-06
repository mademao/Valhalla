//
//  GlutinousView.m
//  GlutinousViewDemo
//
//  Created by 马德茂 on 2016/10/31.
//  Copyright © 2016年 PlutoMa. All rights reserved.
//

#import "GlutinousView.h"

@interface GlutinousView ()
/**
 *  初始圆心
 */
@property (nonatomic, assign) CGPoint startCenter;
/**
 *  初始宽高
 */
@property (nonatomic, assign) CGFloat startWidth;
/**
 *  拖拽时的辅助小圆
 */
@property (nonatomic, strong) UIView *smallCircle;
/**
 *  拖拽时的辅助贝塞尔曲线
 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation GlutinousView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSetting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initSetting];
    }
    return self;
}

#pragma mark - Custom Methods
//初始化设置
- (void)initSetting
{
    //调整视图大小及位置，解决宽高不一致的问题
    self.startCenter = self.center;
    //默认选择较短一边
    if (CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame)) {
        self.startWidth = CGRectGetHeight(self.frame);
    } else {
        self.startWidth = CGRectGetWidth(self.frame);
    }
    self.frame = CGRectMake(self.startCenter.x - self.startWidth / 2., self.startCenter.y - self.startWidth / 2., self.startWidth, self.startWidth);
    self.layer.cornerRadius = self.startWidth / 2.;
    
    //初始化属性设置
    self.glutinousSpace = 50;
    
    //添加拖拽事件
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAction:)];
    [self addGestureRecognizer:panGR];
    
}

//拖拽事件
- (void)panGRAction:(UIPanGestureRecognizer *)gr
{
    //处理大圆位置
    CGPoint transPoint = [gr translationInView:self];
    self.center = CGPointMake(self.startCenter.x + transPoint.x, self.startCenter.y + transPoint.y);
    
    CGFloat ratio = (self.glutinousSpace - [self calculateSpace]) / self.glutinousSpace;
    //处理小圆位置及大小
    if (gr.state == UIGestureRecognizerStateBegan) {
        self.smallCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.startWidth, self.startWidth)];
        self.smallCircle.backgroundColor = self.backgroundColor;
        self.smallCircle.layer.cornerRadius = self.startWidth / 2.;
        [self addSubview:self.smallCircle];
    } else if (gr.state == UIGestureRecognizerStateEnded ||
               gr.state == UIGestureRecognizerStateFailed ||
               gr.state == UIGestureRecognizerStateCancelled) {
        [self.smallCircle removeFromSuperview];
        self.smallCircle = nil;
    }
    if (self.smallCircle) {
        //位置
        CGFloat xSpace = self.startCenter.x - self.center.x;
        CGFloat ySpace = self.startCenter.y - self.center.y;
        self.smallCircle.center = CGPointMake(self.startWidth / 2. + xSpace, self.startWidth / 2. + ySpace);
        //大小
        CGFloat width = self.startWidth * ratio;
        self.smallCircle.frame = CGRectMake(CGRectGetMinX(self.smallCircle.frame), CGRectGetMinY(self.smallCircle.frame), width, width);
        self.smallCircle.layer.cornerRadius = width / 2.;
    }
    
    //处理贝塞尔曲线
    if (gr.state == UIGestureRecognizerStateBegan) {
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.fillColor = self.backgroundColor.CGColor;
        [self.layer addSublayer:self.shapeLayer];
    } else if (gr.state == UIGestureRecognizerStateEnded ||
               gr.state == UIGestureRecognizerStateFailed ||
               gr.state == UIGestureRecognizerStateCancelled) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
    if (self.shapeLayer && [self calculateSpace] > 0) {
        self.shapeLayer.path = [self getBezierPath].CGPath;
    }
    
    //判断是否超出拖拽距离
    if (self.glutinousSpace < [self calculateSpace]) {
        [self.smallCircle removeFromSuperview];
        self.smallCircle = nil;
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
    
    
    //拖拽结束处理
    if (gr.state == UIGestureRecognizerStateEnded) {
        if (self.glutinousSpace < [self calculateSpace]) {
            self.startCenter = self.center;
        } else {
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.35
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                self.center = self.startCenter;
            } completion:nil];
        }
    }
}

//计算拖拽距离
- (CGFloat)calculateSpace
{
    CGFloat xSpace = self.startCenter.x - self.center.x;
    CGFloat ySpace = self.startCenter.y - self.center.y;
    return sqrt(xSpace * xSpace + ySpace * ySpace);
}

//获取贝塞尔曲线
- (UIBezierPath *)getBezierPath
{
    //获取圆心距离
    CGFloat d = [self calculateSpace];
    //获取小圆信息
    CGFloat r1 = CGRectGetWidth(self.smallCircle.frame) / 2.;
    //获取大圆信息
    CGFloat r2 = CGRectGetWidth(self.frame) / 2.;
    //获取两圆横坐标之间距离
    CGFloat xSpace = self.smallCircle.center.x - self.startWidth / 2.;
    xSpace = xSpace > 0 ? xSpace : -xSpace;
    //获取两圆纵坐标之间距离
    CGFloat ySpace = self.smallCircle.center.y - self.startWidth / 2.;
    ySpace = ySpace > 0 ? ySpace : - ySpace;
    //获取三角函数
    CGFloat sin = ySpace / d;
    CGFloat cos = xSpace / d;
    //计算小圆两个点位置，y轴方向，A点相对于B点在上
    //计算大圆两个点位置，y轴方向，C点相对于D点在下
    //计算贝塞尔曲线辅助点, E为BC上辅助点，F为AD上辅助点
    CGFloat xSpace1 = sin * r1;
    CGFloat ySpace1 = cos * r1;
    CGFloat xSpace2 = sin * r2;
    CGFloat ySpace2 = cos * r2;
    CGFloat xSpace3 = cos * d / 2.;
    CGFloat ySpace3 = sin * d / 2.;
    CGPoint pointA, pointB, pointC, pointD, pointE, pointF;
    if (self.smallCircle.center.x < self.startWidth / 2. &&
        self.smallCircle.center.y < self.startWidth / 2.) {
        //小在大左上
        pointA = CGPointMake(self.smallCircle.center.x + xSpace1, self.smallCircle.center.y - ySpace1);
        pointB = CGPointMake(self.smallCircle.center.x - xSpace1, self.smallCircle.center.y + ySpace1);
        pointC = CGPointMake(self.startWidth / 2. - xSpace2, self.startWidth / 2. + ySpace2);
        pointD = CGPointMake(self.startWidth / 2. + xSpace2, self.startWidth / 2. - ySpace2);
        pointE = CGPointMake(pointB.x + xSpace3, pointB.y + ySpace3);
        pointF = CGPointMake(pointA.x + xSpace3, pointA.y + ySpace3);
    } else if (self.smallCircle.center.x < self.startWidth / 2. &&
               self.smallCircle.center.y >= self.startWidth / 2.) {
        //小在大左下
        pointA = CGPointMake(self.smallCircle.center.x - xSpace1, self.smallCircle.center.y - ySpace1);
        pointB = CGPointMake(self.smallCircle.center.x + xSpace1, self.smallCircle.center.y + ySpace1);
        pointC = CGPointMake(self.startWidth / 2. + xSpace2, self.startWidth / 2. + ySpace2);
        pointD = CGPointMake(self.startWidth / 2. - xSpace2, self.startWidth / 2. - ySpace2);
        pointE = CGPointMake(pointB.x + xSpace3, pointB.y - ySpace3);
        pointF = CGPointMake(pointA.x + xSpace3, pointA.y - ySpace3);
    } else if (self.smallCircle.center.x >= self.startWidth / 2. &&
               self.smallCircle.center.y < self.startWidth / 2.) {
        //小在大右上
        pointA = CGPointMake(self.smallCircle.center.x - xSpace1, self.smallCircle.center.y - ySpace1);
        pointB = CGPointMake(self.smallCircle.center.x + xSpace1, self.smallCircle.center.y + ySpace1);
        pointC = CGPointMake(self.startWidth / 2. + xSpace2, self.startWidth / 2. + ySpace2);
        pointD = CGPointMake(self.startWidth / 2. - xSpace2, self.startWidth / 2. - ySpace2);
        pointE = CGPointMake(pointB.x - xSpace3, pointB.y + ySpace3);
        pointF = CGPointMake(pointA.x - xSpace3, pointA.y + ySpace3);
    } else {
        //小在大右下
        pointA = CGPointMake(self.smallCircle.center.x + xSpace1, self.smallCircle.center.y - ySpace1);
        pointB = CGPointMake(self.smallCircle.center.x - xSpace1, self.smallCircle.center.y + ySpace1);
        pointC = CGPointMake(self.startWidth / 2. - xSpace2, self.startWidth / 2. + ySpace2);
        pointD = CGPointMake(self.startWidth / 2. + xSpace2, self.startWidth / 2. - ySpace2);
        pointE = CGPointMake(pointB.x - xSpace3, pointB.y - ySpace3);
        pointF = CGPointMake(pointA.x - xSpace3, pointA.y - ySpace3);
    }
    
    //创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointC controlPoint:pointE];
    [path addLineToPoint:pointD];
    [path addQuadCurveToPoint:pointA controlPoint:pointF];
    
    return path;
}

@end
