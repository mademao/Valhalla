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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"Image1"];
    [self.view addSubview:imageView];
    
    self.navigationController.delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 200, 50);
    backButton.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    [backButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor redColor];
    backButton.layer.cornerRadius = 5.0;
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.frame = CGRectMake(0, 0, 200, 50);
    pushButton.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    [pushButton setTitle:NSLocalizedString(@"Push", nil) forState:UIControlStateNormal];
    [pushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pushButton.backgroundColor = [UIColor redColor];
    pushButton.layer.cornerRadius = 5.0;
    [pushButton addTarget:self action:@selector(pushButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];
}

- (void)backButtonAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushButtonAction:(UIButton *)button {
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
