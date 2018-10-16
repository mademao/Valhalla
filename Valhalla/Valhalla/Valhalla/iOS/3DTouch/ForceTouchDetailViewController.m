//
//  ForceTouchDetailViewController.m
//  Valhalla
//
//  Created by mademao on 2018/10/16.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "ForceTouchDetailViewController.h"

@interface ForceTouchDetailViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ForceTouchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = self.message;
    [self.view addSubview:self.label];
    
    self.title = self.message;
}

///peek时上拉出来的菜单
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    return self.actions;
}

@end
