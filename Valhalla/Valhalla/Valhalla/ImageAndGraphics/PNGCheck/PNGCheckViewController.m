//
//  PNGCheckViewController.m
//  Valhalla
//
//  Created by mademao on 2019/3/22.
//  Copyright © 2019 mademao. All rights reserved.
//

#import "PNGCheckViewController.h"
#import "PNGCheck.h"

@implementation PNGCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *file = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"png"];
    [PNGCheck checkPNGWithPath:[file stringByAppendingPathComponent:@"test.png"]];
}

@end
