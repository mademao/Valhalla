//
//  CreatePDFPreviewView.m
//  Valhalla
//
//  Created by mademao on 2018/9/25.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "CreatePDFPreviewView.h"

@interface CreatePDFPreviewView ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CreatePDFPreviewView

- (instancetype)init {
    if (self = [super initWithFrame:PltScreenBounds]) {
        self.backView = [[UIView alloc] initWithFrame:self.bounds];
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = 0.8;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tapGR.numberOfTapsRequired = 1;
        tapGR.numberOfTouchesRequired = 1;
        [self.backView addGestureRecognizer:tapGR];
        [self addSubview:self.backView];
        
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, PltNavigationBarHeight, self.bounds.size.width, self.bounds.size.height - PltNavigationBarHeight - PltTabBarHeight)];
        [self addSubview:self.webView];
    }
    return self;
}

- (void)showPDF:(NSString *)pdfPath {
    NSURL *pdfURL = [NSURL fileURLWithPath:pdfPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:pdfURL];
    //设置缩放
    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:request];
    [self removeFromSuperview];
    [UIView animateWithDuration:0.2 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        [self removeFromSuperview];
    }];
}

@end
