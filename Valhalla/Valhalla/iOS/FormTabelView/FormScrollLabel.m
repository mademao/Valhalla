//
//  FromScrollLabel.m
//  321
//
//  Created by Pluto on 2017/2/8.
//  Copyright © 2017年 Pluto. All rights reserved.
//

#import "FormScrollLabel.h"

@interface FormTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation FormTimerTarget

- (void)formTimerTargetAction:(NSTimer *)timer
{
    if (self.target) {
        IMP imp = [self.target methodForSelector:self.selector];
        void (*func)(id, SEL, NSTimer*) = (void *)imp;
        func(self.target, self.selector, timer);
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

NSTimer *FormTimerCommonModes(NSTimeInterval time, id target, SEL selector, id userInfo)
{
    FormTimerTarget *timerTarget = [[FormTimerTarget alloc] init];
    timerTarget.target = target;
    timerTarget.selector = selector;
    NSTimer *timer = [NSTimer timerWithTimeInterval:time target:timerTarget selector:@selector(formTimerTargetAction:) userInfo:userInfo repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    timerTarget.timer = timer;
    return timerTarget.timer;
}


@interface FormScrollLabel ()

@property (nonatomic, copy) NSString *realTitle;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FormScrollLabel

- (void)setTitle:(NSString *)title {
    //停止timer
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    //设置背景色，增加在table里的流畅性
    self.backgroundColor = [UIColor grayColor];
    
    //移除子控件
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    self.realTitle = title;
    
    CGFloat titleWidth = [title boundingRectWithSize:CGSizeMake(10000, self.frame.size.height) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    CGFloat titleWidthOffset = 50;
    
    if (titleWidth > self.frame.size.width) {
        //滚动
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth + titleWidthOffset, self.frame.size.height)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(titleWidth + titleWidthOffset, 0, titleWidth + titleWidthOffset, self.frame.size.height)];
        label1.textColor = label2.textColor = [UIColor whiteColor];
        label1.textAlignment = label2.textAlignment = NSTextAlignmentLeft;
        label1.font = label2.font = [UIFont systemFontOfSize:15];
        label1.text = label2.text = self.realTitle;
        [self addSubview:label1];
        [self addSubview:label2];
        self.clipsToBounds = YES;
        //开启滚动
        self.timer = FormTimerCommonModes(0.1, self, @selector(timerAction:), @[label1, label2]);
    } else {
        //不滚动
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.text = self.realTitle;
        [self addSubview:label];
    }
}

- (void)timerAction:(NSTimer *)timer {
    UILabel *label1 = [timer.userInfo objectAtIndex:0];
    UILabel *label2 = [timer.userInfo objectAtIndex:1];
    CGRect frame1 = label1.frame;
    CGRect frame2 = label2.frame;
    
    CGFloat speed = (frame1.size.width - self.frame.size.width) / (2.5 * 10);
    
    if (frame1.origin.x + frame1.size.width <= 0) {
        frame1 = CGRectMake(frame1.size.width, 0, frame1.size.width, frame1.size.height);
    } else {
        frame1 = CGRectMake(frame1.origin.x - speed, frame1.origin.y, frame1.size.width, frame1.size.height);
    }
    
    if (frame2.origin.x + frame2.size.width <= 0) {
        frame2 = CGRectMake(frame2.size.width, 0, frame2.size.width, frame2.size.height);
    } else {
        frame2 = CGRectMake(frame2.origin.x - speed, frame2.origin.y, frame2.size.width, frame2.size.height);
    }
    
    label1.frame = frame1;
    label2.frame = frame2;
}

@end
