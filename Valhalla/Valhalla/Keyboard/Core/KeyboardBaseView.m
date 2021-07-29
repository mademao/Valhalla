//
//  KeyboardBaseView.m
//  Keyboard
//
//  Created by mademao on 2021/7/28.
//  Copyright © 2021 mademao. All rights reserved.
//

#import "KeyboardBaseView.h"

@interface KeyboardBaseView ()

@property (nonatomic, strong) UIView *navigationView;

@end

@implementation KeyboardBaseView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor whiteColor];
        [self initNavigationViewWithTitle:title];
    }
    return self;
}

- (void)initNavigationViewWithTitle:(NSString *)title {
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    self.navigationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.navigationView.layer.borderColor = [UIColor blackColor].CGColor;
    self.navigationView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    [self addSubview:self.navigationView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 50, CGRectGetHeight(self.navigationView.frame));
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:button];

    UILabel *label = [[UILabel alloc] initWithFrame:self.navigationView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [self.navigationView addSubview:label];
    [self.navigationView sendSubviewToBack:label];
}

- (void)buttonAction:(UIButton *)button {
    [self removeFromSuperview];
}

@end
