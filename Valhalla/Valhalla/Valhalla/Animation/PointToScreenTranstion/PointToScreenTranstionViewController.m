//
//  PointToScreenTranstionViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/12.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "PointToScreenTranstionViewController.h"
#import "PointToScreenTranstion.h"
#import "PointToScreenTranstionPresentedViewController.h"

@interface PointToScreenTranstionViewController ()

@end

@implementation PointToScreenTranstionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"Image1"];
    [self.view addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMidX(imageView.frame) - 30, CGRectGetMaxY(imageView.frame) - 80 - 60, 60, 60);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 30;
    button.tag = kPointToScreenTranstionViewTag;
    [button setTitle:NSLocalizedString(@"Present ViewController", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nextAction:(UIButton *)sender {
    PointToScreenTranstionPresentedViewController *viewController = [[PointToScreenTranstionPresentedViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
