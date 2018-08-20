//
//  DigitScrollViewController.m
//  Valhalla
//
//  Created by mademao on 2018/8/20.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "DigitScrollViewController.h"
#import "DigitScrollView.h"

@interface DigitScrollViewController ()

@property (nonatomic, strong) DigitScrollView *digitScrollView;

@end

@implementation DigitScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    self.digitScrollView = [[DigitScrollView alloc] initWithFrame:CGRectMake(50, bounds.size.height / 2.0 - 100, bounds.size.width - 100, 100)];
    self.digitScrollView.digitColor = [UIColor whiteColor];
    self.digitScrollView.digitFont = [UIFont systemFontOfSize:35];
    self.digitScrollView.digitWidth = 50;
    self.digitScrollView.digitHeight = 100;
    self.digitScrollView.digitBackgroundColor = [UIColor blueColor];
    self.digitScrollView.digitBackgroundCornerRadius = 20;
    self.digitScrollView.spaceColor = [UIColor greenColor];
    self.digitScrollView.spaceWidth = 5;
    self.digitScrollView.duration = 3;
    self.digitScrollView.isAscending = NO;
    self.digitScrollView.direction = DigitSVDirectionDownward;
    [self.view addSubview:self.digitScrollView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, bounds.size.width - 100, 50);
    button.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.digitScrollView.frame) + 100);
    [button setTitle:NSLocalizedString(@"Random Number", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:25];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction:(UIButton *)button {
    self.digitScrollView.digit = [NSNumber numberWithInt:arc4random() % 2000];
    NSLog(@"%@", self.digitScrollView.digit);
    [self.digitScrollView startLoadWithAnimation:YES];
}

@end
