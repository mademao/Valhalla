//
//  NavigationAnimationViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/7.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "NavigationAnimationViewController.h"
#import "NavigationAnimationPushedViewController.h"
#import "NavigationAnimation.h"

@interface NavigationAnimationViewController () <UINavigationControllerDelegate>

@end

@implementation NavigationAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationController.delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NavigationAnimationPushedViewController *viewController = [[NavigationAnimationPushedViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    NavigationAnimation *animation = [[NavigationAnimation alloc] init];
    if (operation == UINavigationControllerOperationPush) {
        animation.navigationAnimationType = NavigationAnimationTypePush;
    } else {
        animation.navigationAnimationType = NavigationAnimationTypePop;
    }
    return animation;
}

@end
