//
//  NavigationAnimation.m
//  Valhalla
//
//  Created by mademao on 2018/9/10.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "NavigationAnimation.h"

@implementation NavigationAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.55;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.navigationAnimationType == NavigationAnimationTypePush) {
        [self doPushAnimation:transitionContext];
    } else {
        [self doPopAnimation:transitionContext];
    }
}

//Push动画逻辑
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -0.002;
    containerView.layer.sublayerTransform = transfrom3d;
    fromVC.view.layer.anchorPoint = CGPointMake(0, 0.5);
    fromVC.view.frame = CGRectMake(0, CGRectGetMinY(fromVC.view.frame), CGRectGetWidth(fromVC.view.frame), CGRectGetHeight(fromVC.view.frame));
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        fromVC.view.layer.transform = CATransform3DIdentity;
    }];
}

//Pop动画逻辑
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -0.002;
    containerView.layer.sublayerTransform = transfrom3d;
    fromVC.view.layer.anchorPoint = CGPointMake(1, 0.5);
    fromVC.view.frame = CGRectMake(0, CGRectGetMinY(fromVC.view.frame), CGRectGetWidth(fromVC.view.frame), CGRectGetHeight(fromVC.view.frame));
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
