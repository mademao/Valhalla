//
//  NavigationAnimationPushedViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/10.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "NavigationAnimationPushedViewController.h"

@interface NavigationAnimationPushedViewController ()

@end

@implementation NavigationAnimationPushedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"Image2"];
    [self.view addSubview:imageView];
    
    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    popButton.frame = CGRectMake(0, 0, 200, 50);
    popButton.center = CGPointMake(self.view.center.x, self.view.center.y);
    [popButton setTitle:NSLocalizedString(@"Pop", nil) forState:UIControlStateNormal];
    [popButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    popButton.backgroundColor = [UIColor redColor];
    popButton.layer.cornerRadius = 5.0;
    [popButton addTarget:self action:@selector(popButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popButton];
}

- (void)popButtonAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
