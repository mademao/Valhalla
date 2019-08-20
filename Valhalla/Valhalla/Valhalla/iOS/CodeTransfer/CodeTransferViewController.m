//
//  CodeTransferViewController.m
//  Valhalla
//
//  Created by mademao on 2019/8/20.
//  Copyright © 2019 mademao. All rights reserved.
//

#import "CodeTransferViewController.h"

@implementation CodeTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self convertUTF16WithUnicode:@"1F602"];
}

///unicode转UTF16
- (void)convertUTF16WithUnicode:(NSString *)unicode
{
    uint32_t hex = (uint32_t)strtoul([unicode UTF8String], NULL, 16);
    hex = hex - 0x10000;
    uint32_t hight = hex >> 10;
    uint32_t low = hex - (hight << 10);
    hight = hight | 0xd800;
    low = low | 0xdc00;
    NSLog(@"--->%x %x", hight, low);
}


@end
