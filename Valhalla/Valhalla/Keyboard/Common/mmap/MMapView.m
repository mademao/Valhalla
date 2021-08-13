//
//  MMapView.m
//  Keyboard
//
//  Created by mademao on 2021/7/28.
//  Copyright © 2021 mademao. All rights reserved.
//

#import "MMapView.h"
#import "MMapUtil.h"
#import "KbdConfig.h"

@interface MMapView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) MMapUtil *mmapUtil;

@end

@implementation MMapView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if (self = [super initWithFrame:frame title:title]) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    40,
                                                                    CGRectGetWidth(frame),
                                                                    40)];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.titleLabel.text = @"请点击键盘";
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        CGFloat yOffset = CGRectGetMaxY(self.titleLabel.frame);
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                      yOffset,
                                                                      CGRectGetWidth(frame),
                                                                      CGRectGetHeight(frame) - yOffset)];
        self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.messageLabel];
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableString *message = [NSMutableString string];
    if ([KbdConfig sharedInstance].hasFullAccess) {
        [message appendString:@"完全访问打开状态\n"];
    } else {
        [message appendString:@"完全访问关闭状态\n"];
    }
    NSString *s = [self.mmapUtil read];
    [message appendFormat:@"读取到的数据：%@\n", s];
    if ([KbdConfig sharedInstance].hasFullAccess) {
        s = [NSString stringWithFormat:@"%@", @(arc4random() % 100)];
        [message appendFormat:@"新写入的数据：%@", s];
        [self.mmapUtil write:s];
    }
    self.messageLabel.text = message;
}

- (MMapUtil *)mmapUtil {
    if (_mmapUtil == nil) {
        NSURL *url = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.mademao.Valhalla"];
        NSString *theRootDir = [url.resourceSpecifier copy];
        _mmapUtil = [[MMapUtil alloc] initWithFilePath:[theRootDir stringByAppendingFormat:@"mmaputil.txt"]
                                              readonly:![KbdConfig sharedInstance].hasFullAccess];
    }
    return _mmapUtil;
}

@end
