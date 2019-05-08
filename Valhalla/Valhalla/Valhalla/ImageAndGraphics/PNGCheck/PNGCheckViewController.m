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
    
//    NSString *file = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"png"];
//    [PNGCheck checkPNGWithPath:[file stringByAppendingPathComponent:@"test.png"]];
//    [PNGCheck checkPNGWithPath:@"/Users/mademao/Desktop/输入法6.3.0代码设计.png"];
    [PNGCheck checkPNGWithPath:@"/Users/mademao/Desktop/image0.png"];
}

@end
