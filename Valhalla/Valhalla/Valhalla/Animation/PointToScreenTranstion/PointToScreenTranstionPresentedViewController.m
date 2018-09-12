//
//  PointToScreenTranstionPresentedViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/12.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "PointToScreenTranstionPresentedViewController.h"
#import "PointToScreenTranstion.h"

@interface PointToScreenTranstionPresentedViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation PointToScreenTranstionPresentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"Image2"];
    [self.view addSubview:imageView];
    
    self.transitioningDelegate = self;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMidX(imageView.frame) - 30, CGRectGetMaxY(imageView.frame) - 80 - 60, 60, 60);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 30;
    button.tag = kPointToScreenTranstionViewTag;
    [button setTitle:NSLocalizedString(@"Dismiss", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [PointToScreenTranstion transtionWithType:PointToScreenTranstionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [PointToScreenTranstion transtionWithType:PointToScreenTranstionTypePresent];
}

@end
