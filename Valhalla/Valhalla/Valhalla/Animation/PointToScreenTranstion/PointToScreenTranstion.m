//
//  PointToScreenTranstion.m
//  Valhalla
//
//  Created by mademao on 2018/9/12.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "PointToScreenTranstion.h"

@interface PointToScreenTranstion () <CAAnimationDelegate>

@property (nonatomic, assign) PointToScreenTranstionType type;

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation PointToScreenTranstion

+ (instancetype)transtionWithType:(PointToScreenTranstionType)type {
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(PointToScreenTranstionType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.55;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
        case PointToScreenTranstionTypePresent: {
            [self presentAnimation:transitionContext];
            break;
        }
        case PointToScreenTranstionTypeDismiss: {
            [self dismissAnimation:transitionContext];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Animation
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UINavigationController *fromVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //拿到button，进而来确定动画初始位置
    UIButton *button = [fromVC.view viewWithTag:kPointToScreenTranstionViewTag];
    
    //这个UIView就是执行动画的容器
    UIView *containerView = [transitionContext containerView];
    //我们还要确保controller的view都必须是这个containerView的subview，同时改变View会保持影响
    //比如修改了前一个页面的透明度，在模态回来的时候，这个页面的透明度会保持为修改后的值
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    CGRect frame = CGRectMake(CGRectGetMidX(fromVC.view.frame) - CGRectGetHeight(button.frame) / 2., CGRectGetMinY(button.frame), CGRectGetHeight(button.frame), CGRectGetHeight(button.frame));
    
    //画圆
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithOvalInRect:frame];
    CGFloat x = MAX(frame.origin.x,containerView.frame.size.width - frame.origin.x);
    CGFloat y = MAX(frame.origin.y, containerView.frame.size.height - frame.origin.y);
    
    //求出半径
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor grayColor].CGColor;
    maskLayer.opacity = 0.5;
    maskLayer.path = endCycle.CGPath;
    
    // 下面的mask可以是动画为透明
    //    toVC.view.layer.mask = maskLayer;
    
    self.maskLayer = maskLayer;
    [fromVC.view.layer addSublayer:maskLayer];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.alpha = 0.1;
    }];
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation1.fromValue = (__bridge id _Nullable)(startCycle.CGPath);
    animation1.toValue = (__bridge id _Nullable)(endCycle.CGPath);
    animation1.duration = [self transitionDuration:transitionContext];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @(0.5);
    animation2.toValue = @(1);
    animation2.duration = [self transitionDuration:transitionContext];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation1, animation2];
    group.duration = [self transitionDuration:transitionContext];
    group.delegate = self;
    [group setValue:transitionContext forKey:@"transitionContext"];
    
    [maskLayer addAnimation:group forKey:@"transitionAnimation"];
    
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIButton *button = [toVC.view viewWithTag:2000];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    
    CGRect frame = CGRectMake(CGRectGetMidX(fromVC.view.frame) - CGRectGetHeight(button.frame) / 2., CGRectGetMinY(button.frame), CGRectGetHeight(button.frame), CGRectGetHeight(button.frame));
    
    CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:frame];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor grayColor].CGColor;
    maskLayer.path = startCycle.CGPath;
    maskLayer.opaque = 0.5;
    self.maskLayer = maskLayer;
    fromVC.view.layer.mask = self.maskLayer;
    
    toVC.view.alpha = 0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //因为模态回去之后，该控制器dealloc，所以view的修改无所谓
        fromVC.view.alpha = 0.1;
        toVC.view.alpha = 1;
    }];
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation1.fromValue = (__bridge id _Nullable)(startCycle.CGPath);
    animation1.toValue = (__bridge id _Nullable)(endCycle.CGPath);
    animation1.duration = [self transitionDuration:transitionContext];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @(0.5);
    animation2.toValue = @(1);
    animation2.duration = [self transitionDuration:transitionContext];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation1, animation2];
    group.duration = [self transitionDuration:transitionContext];
    group.delegate = self;
    [group setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:group forKey:@"dismissAnimation"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    switch (self.type) {
        case PointToScreenTranstionTypePresent: {
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            //更新内部视图控制器状态的转换在转换结束
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [self.maskLayer removeFromSuperlayer];
            // 因为此时对fromVC.view的修改是保持的，所以为了避免模态回来时view正常，要在此恢复view
            [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.alpha = 1;
            break;
        }
        case PointToScreenTranstionTypeDismiss: {
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [self.maskLayer removeFromSuperlayer];
            if (![transitionContext transitionWasCancelled]) {
                [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            }
            
            break;
        }
        default:
            break;
    }
}

@end
