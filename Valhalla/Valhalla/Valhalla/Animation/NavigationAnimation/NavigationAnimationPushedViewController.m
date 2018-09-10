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
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
