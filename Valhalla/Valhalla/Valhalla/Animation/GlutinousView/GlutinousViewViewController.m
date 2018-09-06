//
//  GlutinousViewViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/6.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "GlutinousViewViewController.h"
#import "GlutinousView.h"

@interface GlutinousViewViewController ()

@property (nonatomic, strong) GlutinousView *glutinousView;

@end

@implementation GlutinousViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    label.font = [UIFont systemFontOfSize:24];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"Please drag the red view", nil);
    [self.view addSubview:label];
    
    self.glutinousView = [[GlutinousView alloc] initWithFrame:CGRectMake(label.center.x - 25, label.center.y - 100, 50, 50)];
    self.glutinousView.glutinousSpace = 300;
    self.glutinousView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.glutinousView];
}

@end
