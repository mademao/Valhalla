//
//  KeychainViewController.m
//  Valhalla
//
//  Created by 马德茂 on 2018/8/18.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "KeychainViewController.h"
#import "KeychainUtil.h"

@interface KeychainViewController ()

@end

@implementation KeychainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    [KeychainUtil setServiceName:@"com.mademao"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, bounds.size.width - 100, 50);
    button.center = self.view.center;
    [button setTitle:NSLocalizedString(@"Get Identifier", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:25];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction:(UIButton *)button {
    NSString *identifier = [KeychainUtil getUUID];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Identifier", nil) message:identifier preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dnoeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Done", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:dnoeAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
