//
//  CompressImageViewController.m
//  Valhalla
//
//  Created by mademao on 2019/7/1.
//  Copyright © 2019 mademao. All rights reserved.
//

#import "CompressImageViewController.h"
#import "CompressImageUtil.h"

@interface CompressImageViewController ()

@end

@implementation CompressImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}


#pragma mark - UI

- (void)setupUI
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 50);
    button.center = self.view.center;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [button setTitle:NSLocalizedString(@"Compress Image", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(compressImageAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)compressImageAction
{
    NSString *filePath = [[NSBundle mainBundle] bundlePath];
    filePath = [filePath stringByAppendingFormat:@"/gif/cat.gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    NSString *compressImagePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    compressImagePath = [compressImagePath stringByAppendingPathComponent:@"compress_image.gif"];
    
    BOOL success = [CompressImageUtil compressionImageWithImageData:imageData compressImagePath:compressImagePath maxLength:100];
    
    NSString *message = @"压缩失败";
    if (success) {
        message = [NSString stringWithFormat:@"压缩成功，压缩后图片路径（已复制到粘贴板）:\n%@", compressImagePath];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:compressImagePath];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"压缩完成" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
