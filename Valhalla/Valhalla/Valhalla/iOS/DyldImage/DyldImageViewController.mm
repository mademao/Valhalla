//
//  DyldImageViewController.m
//  Valhalla
//
//  Created by mademao on 2020/5/10.
//  Copyright © 2020 mademao. All rights reserved.
//

#import "DyldImageViewController.h"
#import "mdm_dyld_image_util.h"

@interface DyldImageViewController ()

@end

@implementation DyldImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    mdm_dyld_load_current_dyld_image_info();
    mdm_dyld_print_info(mdm_current_dyld_image_info);
}

@end
