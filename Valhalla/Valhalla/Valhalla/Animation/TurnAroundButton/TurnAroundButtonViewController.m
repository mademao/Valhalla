//
//  TurnAroundButtonViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/7.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "TurnAroundButtonViewController.h"
#import "TurnAroundButton.h"

@interface TurnAroundButtonViewController ()

@property (nonatomic, strong) TurnAroundButton *turnAroundButton;

@end

@implementation TurnAroundButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.turnAroundButton = [[TurnAroundButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    self.turnAroundButton.center = CGPointMake(CGRectGetMidX(self.view.frame), 200);
    self.turnAroundButton.backColor = [UIColor colorWithRed:47 / 255. green:129 / 255. blue:215 / 255. alpha:1.0];
    self.turnAroundButton.clickColor = [UIColor grayColor];
    self.turnAroundButton.title = @"登录";
    self.turnAroundButton.duration = 1.3;
    [self.view addSubview:self.turnAroundButton];
    
    [self.turnAroundButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopButton.frame = CGRectMake(0, 0, 200, 50);
    stopButton.center = CGPointMake(self.view.center.x, self.view.plt_height - 200);
    [stopButton setTitle:NSLocalizedString(@"Stop Animation", nil) forState:UIControlStateNormal];
    [stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    stopButton.backgroundColor = [UIColor colorWithRed:47 / 255. green:129 / 255. blue:215 / 255. alpha:1.0];
    stopButton.layer.cornerRadius = 5.0;
    [stopButton addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resetButton.frame = CGRectMake(0, 0, 200, 50);
    resetButton.center = CGPointMake(self.view.center.x, self.view.plt_height - 100);
    [resetButton setTitle:NSLocalizedString(@"Reset Animation", nil) forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetButton.backgroundColor = [UIColor colorWithRed:47 / 255. green:129 / 255. blue:215 / 255. alpha:1.0];
    resetButton.layer.cornerRadius = 5.0;
    [resetButton addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetButton];
}

- (void)loginButtonAction:(TurnAroundButton *)button
{
    //模拟耗时操作，比如请求登录接口，或存储登录信息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.turnAroundButton stopAnimation];
    });
}

- (void)stopAction:(UIButton *)sender {
    [self.turnAroundButton stopAnimation];
}

- (void)resetAction:(UIButton *)sender {
    [self.turnAroundButton resetStatus];
}

@end
