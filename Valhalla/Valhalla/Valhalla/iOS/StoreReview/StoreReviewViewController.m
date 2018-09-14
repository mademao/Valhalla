//
//  StoreReviewViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/14.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "StoreReviewViewController.h"
#import <StoreKit/StoreKit.h>

@interface StoreReviewViewController ()

@end

@implementation StoreReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 50);
    button.center = self.view.center;
    button.backgroundColor = [UIColor colorWithRed:254.0 / 255.0 green:96.0 / 255.0 blue:88.0 / 255.0 alpha:1.0];
    [button setTitle:NSLocalizedString(@"Review", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 8.0;
    [button addTarget:self action:@selector(reviewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)reviewAction:(UIButton *)button {
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    }
}

@end
