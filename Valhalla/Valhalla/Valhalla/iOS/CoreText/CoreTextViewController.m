//
//  CoreTextViewController.m
//  Valhalla
//
//  Created by mademao on 2018/12/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "CoreTextViewController.h"
#import "CoreTextView.h"

@interface CoreTextViewController ()

@end

@implementation CoreTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CoreTextView *view = [[CoreTextView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    view.center = self.view.center;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

@end
