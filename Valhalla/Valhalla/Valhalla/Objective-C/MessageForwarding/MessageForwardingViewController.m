//
//  MessageForwardingViewController.m
//  Valhalla
//
//  Created by mademao on 2018/8/17.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "MessageForwardingViewController.h"
#import "ClassA.h"

@interface MessageForwardingViewController ()

@end

@implementation MessageForwardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:25];
    label.text = NSLocalizedString(@"Look Message At Console", nil);
    [self.view addSubview:label];
    
    [ClassA classTestMethod1:@"333"];
    
    ClassA *a = [[ClassA alloc] init];
    [a testMethod1:@"123"];
    
    [a testMethod2:@"321"];
    
    [a testMethod3:@"222"];
}

@end
