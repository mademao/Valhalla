//
//  CreateQRCodeViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/21.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "CreateQRCodeViewController.h"
#import "QRCodeCreater.h"

@interface CreateQRCodeViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CreateQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(50, PltNavigationBarHeight + 30, PltScreenWidth - 100, 50)];
    self.textField.layer.borderColor = [UIColor grayColor].CGColor;
    self.textField.layer.borderWidth = 1.0;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.textField.plt_x, self.textField.plt_maxY + 30, self.textField.plt_width, 50);
    [button setTitle:NSLocalizedString(@"Create QR Code", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 8.0;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(createButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    CGFloat length = MIN(self.textField.plt_width, PltScreenHeight - button.plt_maxY - 50 - PltTabBarHeight);
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, button.plt_maxY + 50, length, length)];
    self.imageView.center = CGPointMake(PltScreenWidth / 2.0, self.imageView.center.y);
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.imageView.layer.borderWidth = 1.0;
    [self.view addSubview:self.imageView];
}

- (void)createButtonAction:(UIButton *)button {
    [self.textField resignFirstResponder];
    self.imageView.image = [QRCodeCreater createQRCodeWithContent:self.textField.text imageLength:self.imageView.plt_width];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
