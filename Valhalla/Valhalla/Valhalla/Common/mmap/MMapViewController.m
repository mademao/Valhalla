//
//  MMapViewController.m
//  Valhalla
//
//  Created by mademao on 2021/7/29.
//  Copyright © 2021 mademao. All rights reserved.
//

#import "MMapViewController.h"
#import "MMapUtil.h"

@interface MMapViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) MMapUtil *mmapUtil;

@end

@implementation MMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                100,
                                                                CGRectGetWidth(bounds),
                                                                80)];
    self.titleLabel.text = @"请点击屏幕";
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    CGFloat yOffset = CGRectGetMaxY(self.titleLabel.frame);
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                                   yOffset,
                                                                   CGRectGetWidth(bounds) - 150,
                                                                   50)];
    self.textField.placeholder = @"点击调起键盘";
    self.textField.layer.borderColor = [UIColor blackColor].CGColor;
    self.textField.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    [self.view addSubview:self.textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(CGRectGetMaxX(self.textField.frame),
                              CGRectGetMinY(self.textField.frame),
                              CGRectGetWidth(bounds) - CGRectGetWidth(self.textField.frame),
                              CGRectGetHeight(self.textField.frame));
    [button setTitle:@"收起键盘" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    yOffset = CGRectGetMaxY(self.textField.frame);
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  yOffset,
                                                                  CGRectGetWidth(bounds),
                                                                  CGRectGetHeight(bounds) - yOffset - 200)];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.messageLabel];
}

- (void)buttonAction:(UIButton *)button {
    [self.textField endEditing:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableString *message = [NSMutableString string];
    NSString *s = [self.mmapUtil read];
    [message appendFormat:@"读取到的数据：%@\n", s];
    s = [NSString stringWithFormat:@"%@", @(arc4random() % 100)];
    [message appendFormat:@"新写入的数据：%@", s];
    [self.mmapUtil write:s];
    self.messageLabel.text = message;
}

- (MMapUtil *)mmapUtil {
    if (_mmapUtil == nil) {
        NSURL *url = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.mademao.Valhalla"];
        NSString *theRootDir = [url.resourceSpecifier copy];
        _mmapUtil = [[MMapUtil alloc] initWithFilePath:[theRootDir stringByAppendingFormat:@"mmaputil.txt"]
                                              readonly:NO];
    }
    return _mmapUtil;
}

@end
