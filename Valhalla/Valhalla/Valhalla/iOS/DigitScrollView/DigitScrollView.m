//
//  DigitScrollView.m
//  DigitScrollViewExample
//
//  Created by 马德茂 on 16/8/26.
//  Copyright © 2016年 MDM. All rights reserved.
//

#import "DigitScrollView.h"

static NSString *DigitScrollViewAnimation = @"DigitScrollViewAnimation";

@interface DigitScrollView ()

@property (nonatomic, strong) NSMutableArray<NSString *> *digitText;
@property (nonatomic, strong) NSMutableArray<CAScrollLayer *> *scrollLayers;
@property (nonatomic, strong) NSMutableArray<UILabel *> *scrollLabels;
@property (nonatomic, strong) NSMutableArray<CALayer *> *staticLayers;
@property (nonatomic, strong) NSMutableArray<UILabel *> *staticLabels;
@end

@implementation DigitScrollView
#pragma mark - public method
- (void)startLoadWithAnimation:(BOOL)animation
{
    for (CALayer *layer in self.scrollLayers) {
        [layer removeFromSuperlayer];
    }
    for (CALayer *layer in self.staticLayers) {
        [layer removeFromSuperlayer];
    }
    
    [self.digitText removeAllObjects];
    [self.scrollLayers removeAllObjects];
    [self.scrollLabels removeAllObjects];
    [self.staticLayers removeAllObjects];
    [self.staticLabels removeAllObjects];
    
    if (animation) {
        [self prepareAnimation];
        [self createAnimation];
    } else {
        [self createLayers];
    }
}

- (void)stopAnimation
{
    for(CALayer *layer in self.scrollLayers){
        [layer removeAnimationForKey:DigitScrollViewAnimation];
    }
}

#pragma mark - private method
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadDefaultSetting];
    }
    return self;
}

/**
 *  进行默认设置
 */
- (void)loadDefaultSetting
{
    self.digit = @(0);
    self.digitColor = [UIColor blackColor];
    self.digitFont = [UIFont systemFontOfSize:17];
    self.digitWidth = 0;
    self.digitHeight = CGRectGetHeight(self.frame);
    self.digitBackgroundColor = [UIColor whiteColor];
    self.digitBackgroundCornerRadius = 0.;
    self.spaceWidth = 0.;
    self.spaceColor = [UIColor whiteColor];
    self.duration = 1.5;
    self.durationOffset = 0.2;
    self.density = 5;
    self.isAscending = YES;
    self.direction = DigitSVDirectionUpward;
}

/**
 *  准备动画设置
 */
- (void)prepareAnimation
{
    [self createDigitText];
    [self createScrollLayers];
}

/**
 *  创建静态展示的layers
 */
- (void)createLayers
{
    [self createDigitText];
    [self createStaticLayers];
}

/**
 *  创建所要显示的数字数组
 */
- (void)createDigitText
{
    NSString *digitString = [self.digit stringValue];
    
    for (NSUInteger i = 0; i < digitString.length; i++) {
        [self.digitText addObject:[digitString substringWithRange:NSMakeRange(i, 1)]];
    }
}

/**
 *  创建所需要展示数字layers
 */
- (void)createScrollLayers
{
    self.backgroundColor = self.spaceColor;
    
    CGFloat width = roundf((CGRectGetWidth(self.frame) - ((self.digitText.count - 1) * self.spaceWidth)) / self.digitText.count);
    if (self.digitWidth < width && self.digitWidth != 0) {
        width = self.digitWidth;
    }
    CGFloat height = self.digitHeight;
    if (self.digitHeight > CGRectGetHeight(self.frame)) {
        height = CGRectGetHeight(self.frame);
    }
    CGFloat xOffset = (CGRectGetWidth(self.frame) - (self.digitText.count - 1) * self.spaceWidth - (width * self.digitText.count)) / 2.;
    CGFloat yOffset = (CGRectGetHeight(self.frame) - height) / 2.;
    
    for (NSUInteger i = 0; i < self.digitText.count; i++) {
        CAScrollLayer *layer = [CAScrollLayer layer];
        layer.frame = CGRectMake(roundf((width + self.spaceWidth) * i) + xOffset, yOffset, width, height);
        layer.backgroundColor = self.digitBackgroundColor.CGColor;
        layer.cornerRadius = self.digitBackgroundCornerRadius;
        [self.scrollLayers addObject:layer];
        [self.layer addSublayer:layer];
    }
    
    for (NSUInteger i = 0; i < self.digitText.count; i++) {
        CAScrollLayer *layer = self.scrollLayers[i];
        NSString *digitText = self.digitText[i];
        [self createContentForLayer:layer withDigitText:digitText];
    }
}

/**
 *  创建静态layers
 */
- (void)createStaticLayers
{
    self.backgroundColor = self.spaceColor;
    
    CGFloat width = roundf((CGRectGetWidth(self.frame) - ((self.digitText.count - 1) * self.spaceWidth)) / self.digitText.count);
    if (self.digitWidth < width && self.digitWidth != 0) {
        width = self.digitWidth;
    }
    CGFloat height = self.digitHeight;
    if (self.digitHeight > CGRectGetHeight(self.frame)) {
        height = CGRectGetHeight(self.frame);
    }
    CGFloat xOffset = (CGRectGetWidth(self.frame) - (self.digitText.count - 1) * self.spaceWidth - (width * self.digitText.count)) / 2.;
    CGFloat yOffset = (CGRectGetHeight(self.frame) - height) / 2.;
    
    for (NSUInteger i = 0; i < self.digitText.count; i++) {
        UILabel *label = [self createLabel:self.digitText[i]];
        label.frame = CGRectMake(roundf((width + self.spaceWidth) * i) + xOffset, yOffset, width, height);
        label.layer.backgroundColor = self.digitBackgroundColor.CGColor;
        label.layer.cornerRadius = self.digitBackgroundCornerRadius;
        [self.layer addSublayer:label.layer];
        [self.staticLayers addObject:label.layer];
        [self.staticLabels addObject:label];
    }
}

/**
 *  创建滚动layers
 */
- (void)createContentForLayer:(CAScrollLayer *)layer withDigitText:(NSString *)digitText
{
    NSInteger digit = [digitText integerValue];
    
    NSMutableArray *digitForScroll = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < self.density + 1; i++) {
        if (self.isAscending) {
            [digitForScroll addObject:[NSString stringWithFormat:@"%@", @((digit - (self.density + 1) + i + 10) % 10)]];
        } else {
            [digitForScroll addObject:[NSString stringWithFormat:@"%@", @((digit + self.density + 1  + 10 - i) % 10)]];
        }
    }
    
    [digitForScroll addObject:digitText];

    CGFloat height = CGRectGetHeight(layer.frame) * (digitForScroll.count - 1);
    if (!self.direction) {
        height = - height;
    }
    for (NSString *string in digitForScroll) {
        UILabel *stringLabel = [self createLabel:string];
        stringLabel.frame = CGRectMake(0, height, CGRectGetWidth(layer.frame), CGRectGetHeight(layer.frame));
        [layer addSublayer:stringLabel.layer];
        [self.scrollLabels addObject:stringLabel];
        if (!self.direction) {
            height += CGRectGetHeight(layer.frame);
        } else {
            height -= CGRectGetHeight(layer.frame);
        }
    }
}

/**
 *  创建展示数字label
 */
- (UILabel *)createLabel:(NSString *)string
{
    UILabel *label = [UILabel new];
    
    label.textColor = self.digitColor;
    label.font = self.digitFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    
    label.text = string;
    
    return label;
}

/**
 *  创建动画
 */
- (void)createAnimation
{
    CFTimeInterval duration = self.duration - (self.digitText.count * self.durationOffset);
    CFTimeInterval offset = 0;
    
    for (CALayer *scrollLayer in self.scrollLayers) {
        CGFloat maxY = [[scrollLayer.sublayers firstObject] frame].origin.y;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
        animation.duration = duration + offset;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        animation.fromValue = [NSNumber numberWithFloat:-maxY];
        animation.toValue = @(0);
        
        [scrollLayer addAnimation:animation forKey:DigitScrollViewAnimation];
        offset += self.durationOffset;
    }
}

#pragma mark - lazyload

- (NSMutableArray<NSString *> *)digitText
{
    if (!_digitText) {
        self.digitText = [NSMutableArray array];
    }
    return _digitText;
}

- (NSMutableArray<CAScrollLayer *> *)scrollLayers
{
    if (!_scrollLayers) {
        self.scrollLayers = [NSMutableArray array];
    }
    return _scrollLayers;
}

- (NSMutableArray<UILabel *> *)scrollLabels
{
    if (!_scrollLabels) {
        self.scrollLabels = [NSMutableArray array];
    }
    return _scrollLabels;
}

- (NSMutableArray<CALayer *> *)staticLayers
{
    if (!_staticLayers) {
        self.staticLayers = [NSMutableArray array];
    }
    return _staticLayers;
}

- (NSMutableArray<UILabel *> *)staticLabels
{
    if (!_staticLabels) {
        self.staticLabels = [NSMutableArray array];
    }
    return _staticLabels;
}
@end
