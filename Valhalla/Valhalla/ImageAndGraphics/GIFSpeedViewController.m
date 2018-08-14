//
//  GIFSpeedViewController.m
//  Valhalla
//
//  Created by 马德茂 on 2018/8/12.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "GIFSpeedViewController.h"

@interface GIFSpeedViewController ()

@property (nonatomic, strong) UIButton *downloadButton;

//@property (nonatomic,)

@end

@implementation GIFSpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.downloadButton];
}

- (void)downloadImage {
    UIActivityIndicatorView *activetyIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activetyIndicatorView.center = self.view.center;
    activetyIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:activetyIndicatorView];
    [activetyIndicatorView startAnimating];
    return;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/mademao/Resources/master/img/fish.gif"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [session finishTasksAndInvalidate];
            [activetyIndicatorView stopAnimating];
            if (data) {
                UIImage *image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
                NSLog(@"123");
            } else {
                
            }
        });
    }];
    [dataTask resume];
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

@end
