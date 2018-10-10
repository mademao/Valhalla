//
//  ImageOrientationDetailViewController.m
//  Valhalla
//
//  Created by mademao on 2018/10/9.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "ImageOrientationDetailViewController.h"
#import "UIImage+FixOrientation.h"

@interface ImageOrientationDetailViewController ()

@property (nonatomic, assign) UIImageOrientation imageOrientation;

@property (nonatomic, strong) UIImageView *showImageView;

@property (nonatomic, strong) UIImageView *originalImageView;

@property (nonatomic, strong) UIImageView *fixImageView;

@end

@implementation ImageOrientationDetailViewController

- (instancetype)initWithImageOrientation:(UIImageOrientation)imageOrientation
{
    if (self = [super init]) {
        self.imageOrientation = imageOrientation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self downloadImage];
}

- (void)downloadImage
{
    NSString *fileName = [NSString stringWithFormat:@"ImageOrientation%ld.JPG", (long)self.imageOrientation];
    NSString *localFilePath = [PltCachePath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:localFilePath]) {
        [self updateImageWithImageData:[NSData dataWithContentsOfFile:localFilePath]];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *filePath = [NSString stringWithFormat:@"https://raw.githubusercontent.com/mademao/Resources/master/img/ImageOrientation/%@", fileName];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:filePath] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [session finishTasksAndInvalidate];
                if (data) {
                    [data writeToFile:localFilePath atomically:YES];
                    [self updateImageWithImageData:data];
                } else {
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = NSLocalizedString(@"Download Fail", nil);
                }
            });
        }];
        [dataTask resume];
    }
}

- (void)updateImageWithImageData:(NSData *)imageData
{
    [self setupImageViews];
    
    UIImage *showImage = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
    UIImage *originalImage = [UIImage imageWithCGImage:showImage.CGImage scale:showImage.scale orientation:UIImageOrientationUp];
    UIImage *fixImage = [showImage fixOrientation];
    
    self.showImageView.image = showImage;
    self.originalImageView.image = originalImage;
    self.fixImageView.image = fixImage;
}

- (void)setupImageViews
{
    if (_showImageView) {
        return;
    }
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    CGFloat bottomOffsetY = 0;
    if (@available(iOS 11.0, *))
        bottomOffsetY = window.safeAreaInsets.bottom;
    
    CGFloat imageWidth = (PltScreenHeight - PltNavigationBarHeight - bottomOffsetY - 30) / 3.0;
    imageWidth = imageWidth > self.view.frame.size.width ? self.view.frame.size.width : imageWidth;
    
    CGFloat xOffset = (self.view.frame.size.width - imageWidth) / 2.0;
    
    UILabel *label = nil;
    
    self.showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, imageWidth, imageWidth)];
    self.showImageView.backgroundColor = [UIColor whiteColor];
    self.showImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.showImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.showImageView.layer.borderWidth = 1.0f;
    [self.view addSubview:self.showImageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, self.showImageView.plt_y, xOffset - 10, self.showImageView.plt_height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = YES;
    label.text = NSLocalizedString(@"Show Image", nil);
    [self.view addSubview:label];
    
    self.originalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, CGRectGetMaxY(self.showImageView.frame) + 15, imageWidth, imageWidth)];
    self.originalImageView.backgroundColor = [UIColor whiteColor];
    self.originalImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.originalImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.originalImageView.layer.borderWidth = 1.0f;
    [self.view addSubview:self.originalImageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, self.originalImageView.plt_y, xOffset - 10, self.originalImageView.plt_height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = YES;
    label.text = NSLocalizedString(@"Original Image", nil);
    [self.view addSubview:label];
    
    self.fixImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, CGRectGetMaxY(self.originalImageView.frame) + 15, imageWidth, imageWidth)];
    self.fixImageView.backgroundColor = [UIColor whiteColor];
    self.fixImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.fixImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.fixImageView.layer.borderWidth = 1.0f;
    [self.view addSubview:self.fixImageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, self.fixImageView.plt_y, xOffset - 10, self.fixImageView.plt_height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = YES;
    label.text = NSLocalizedString(@"Fix Image", nil);
    [self.view addSubview:label];
}

@end
