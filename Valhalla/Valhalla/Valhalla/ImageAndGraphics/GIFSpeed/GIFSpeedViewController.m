//
//  GIFSpeedViewController.m
//  Valhalla
//
//  Created by 马德茂 on 2018/8/12.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "GIFSpeedViewController.h"
#import "GIFFileTool.h"
#import <YYImage/YYImage.h>

static NSString * const kGSVCFileName = @"GIFSpeedViewController.gif";

@interface GIFSpeedViewController ()

@property (nonatomic, strong) UIButton *downloadButton;

@property (nonatomic, strong) YYAnimatedImageView *imageView;

@property (nonatomic, strong) UIButton *changeSpeedButton;

@end

@implementation GIFSpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.downloadButton];
}

- (void)downloadImage {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/mademao/Resources/master/img/fish.gif"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [session finishTasksAndInvalidate];
            if (data) {
                [data writeToFile:[PltCachePath stringByAppendingPathComponent:kGSVCFileName] atomically:YES];
                self.downloadButton.hidden = YES;
                self.imageView.hidden = NO;
                self.changeSpeedButton.hidden = NO;
                [self updateImage];
            } else {
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"Download Fail", nil);
            }
        });
    }];
    [dataTask resume];
}

- (void)updateImage {
    YYImage *image = [YYImage imageWithData:[NSData dataWithContentsOfFile:[PltCachePath stringByAppendingPathComponent:kGSVCFileName]] scale:[UIScreen mainScreen].scale];
    self.imageView.image = image;
}

- (void)changeSpeedButtonAction {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose Multiple", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Half", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [GIFFileTool changeGIFSpeedWithGIFFilePath:[PltCachePath stringByAppendingPathComponent:kGSVCFileName] changeSpeedType:GIFChangeSpeedTypeMultiple value:2];
        [self updateImage];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Double", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [GIFFileTool changeGIFSpeedWithGIFFilePath:[PltCachePath stringByAppendingPathComponent:kGSVCFileName] changeSpeedType:GIFChangeSpeedTypeMultiple value:0.5];
        [self updateImage];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}


#pragma mark - lazy load

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.frame = CGRectMake(0, 0, bounds.size.width - 100, 50);
        _downloadButton.center = self.view.center;
        [_downloadButton setTitle:NSLocalizedString(@"Download GIF", nil) forState:UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _downloadButton.titleLabel.font = [UIFont systemFontOfSize:25];
        _downloadButton.layer.borderColor = [UIColor blackColor].CGColor;
        _downloadButton.layer.borderWidth = 1.0;
        _downloadButton.layer.cornerRadius = 5.0;
        [_downloadButton addTarget:self action:@selector(downloadImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

- (YYAnimatedImageView *)imageView {
    if (!_imageView) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        _imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(50, 150, bounds.size.width - 100, bounds.size.width - 100)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];
        _imageView.hidden = YES;
    }
    return _imageView;
}

- (UIButton *)changeSpeedButton {
    if (!_changeSpeedButton) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        _changeSpeedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeSpeedButton.frame = CGRectMake(0, 0, bounds.size.width - 100, 50);
        _changeSpeedButton.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.imageView.frame) + 80);
        [_changeSpeedButton setTitle:NSLocalizedString(@"Change GIF Speed", nil) forState:UIControlStateNormal];
        [_changeSpeedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _changeSpeedButton.titleLabel.font = [UIFont systemFontOfSize:25];
        _changeSpeedButton.layer.borderColor = [UIColor blackColor].CGColor;
        _changeSpeedButton.layer.borderWidth = 1.0;
        _changeSpeedButton.layer.cornerRadius = 5.0;
        [_changeSpeedButton addTarget:self action:@selector(changeSpeedButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_changeSpeedButton];
        _changeSpeedButton.hidden = YES;
    }
    return _changeSpeedButton;
}

@end
