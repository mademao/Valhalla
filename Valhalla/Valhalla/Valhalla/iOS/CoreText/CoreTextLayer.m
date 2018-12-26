//
//  CoreTextLayer.m
//  Valhalla
//
//  Created by mademao on 2018/12/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "CoreTextLayer.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

///代理释放回调
static void DeallocCallback(void *ref)
{
    UIImage *image = (__bridge id)ref;
    image = nil;
}

///代理获取Ascent回调
static CGFloat GetAscentCallback(void *ref)
{
    UIImage *image = (__bridge id)ref;
    return image.size.height / 2.0;
}

///代理获取Descent回调
static CGFloat GetDescentCallback(void *ref)
{
    UIImage *image = (__bridge id)ref;
    return image.size.height / 2.0;
}

///代理获取Width回调
static CGFloat GetWidthCallback(void *ref)
{
    UIImage *image = (__bridge id)ref;
    return image.size.width;
}


@interface CoreTextLayer ()

///CoreText中frame信息
@property (nonatomic, assign) CTFrameRef frameRef;
///原始字符串数据
@property (nonatomic, strong) NSMutableAttributedString *originalAttributedString;

@end

@implementation CoreTextLayer

- (instancetype)init
{
    self = [super init];
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    self.contentsScale = scale;
    [self initOriginalString];
    return self;
}

///构造展示数据
- (void)initOriginalString
{
    //初始化需要绘制文字
    NSString *originalString = @"This is test string, just test string";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString];
    self.originalAttributedString = attributedString;
    
    //设置字体
    UIFont *italicFont = [UIFont italicSystemFontOfSize:20];
    [attributedString addAttribute:NSFontAttributeName value:italicFont range:NSMakeRange(0, 5)];
    
    //设置斜体
    UIFont *font = [UIFont systemFontOfSize:17];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(5, originalString.length - 5)];
    
    //设置连字
    NSNumber *number = [NSNumber numberWithInt:1];
    [attributedString addAttribute:NSLigatureAttributeName value:number range:NSMakeRange(0, originalString.length)];
    
    //设置下划线
    //    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithUnsignedInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, originalString.length)];
    //    [attributedString addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, originalString.length)];
    
    //设置字体间隔
    [attributedString addAttribute:NSKernAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(0, originalString.length)];
    
    //文本段落排版格式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 10;
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.firstLineHeadIndent = 10;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, originalString.length)];
    
    
    //画图片
    NSMutableAttributedString *attachmentAttributedString = [[NSMutableAttributedString alloc] initWithString:@"\uFFFC"];
    UIImage *attachmentImage = [UIImage imageNamed:@"dribbble64_imageio"];
    [attachmentAttributedString addAttribute:@"TheImage" value:attachmentImage range:NSMakeRange(0, attachmentAttributedString.string.length)];
    //构造回调
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = DeallocCallback;
    callbacks.getAscent = GetAscentCallback;
    callbacks.getDescent = GetDescentCallback;
    callbacks.getWidth = GetWidthCallback;
    CTRunDelegateRef delegateRef = CTRunDelegateCreate(&callbacks, (__bridge void *)attachmentImage);
    [attachmentAttributedString addAttribute:(__bridge id)kCTRunDelegateAttributeName value:(__bridge id)delegateRef range:NSMakeRange(0, attachmentAttributedString.string.length)];
    CFRelease(delegateRef);
    [attributedString appendAttributedString:attachmentAttributedString];
    
    //画第二个图片
    NSMutableAttributedString *attachmentAttributedString2 = [[NSMutableAttributedString alloc] initWithString:@"\uFFFC"];
    UIImage *attachmentImage2 = [UIImage imageNamed:@"dribbble256_imageio"];
    [attachmentAttributedString2 addAttribute:@"TheImage" value:attachmentImage2 range:NSMakeRange(0, attachmentAttributedString2.string.length)];
    //构造回调
    CTRunDelegateCallbacks callbacks2;
    callbacks2.version = kCTRunDelegateCurrentVersion;
    callbacks2.dealloc = DeallocCallback;
    callbacks2.getAscent = GetAscentCallback;
    callbacks2.getDescent = GetDescentCallback;
    callbacks2.getWidth = GetWidthCallback;
    CTRunDelegateRef delegateRef2 = CTRunDelegateCreate(&callbacks2, (__bridge void *)attachmentImage2);
    [attachmentAttributedString2 addAttribute:(__bridge id)kCTRunDelegateAttributeName value:(__bridge id)delegateRef2 range:NSMakeRange(0, attachmentAttributedString2.string.length)];
    CFRelease(delegateRef2);
    [attributedString appendAttributedString:attachmentAttributedString2];

}

///若在view里设置了layer.setNeedsDisplay，则在下一次刷新屏幕时会调用该方法
- (void)display
{
    CGSize drawSize = self.bounds.size;
    drawSize.width *= self.contentsScale;
    drawSize.height *= self.contentsScale;
    
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.originalAttributedString);
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, drawSize.width, drawSize.height));
    self.frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, self.originalAttributedString.string.length), pathRef, NULL);
    
    CGPathRelease(pathRef);
    CFRelease(frameSetterRef);
    
    //开始绘制
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //转换坐标
    CGContextTranslateCTM(context, 0, drawSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //设置背景
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextAddRect(context, CGRectMake(0, 0, drawSize.width, drawSize.height));
    CGContextFillPath(context);
    
    //会自动画出识别出来的属性
    CTFrameDraw(self.frameRef, context);
    
    CFArrayRef lines = CTFrameGetLines(self.frameRef);
    CGPoint origins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), origins);
    
    for (int lineIndex = 0; lineIndex < CFArrayGetCount(lines); lineIndex++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        for (int runIndex = 0; runIndex < CFArrayGetCount(runs); runIndex++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, runIndex);
            
            NSDictionary *runAttributed = (__bridge NSDictionary *)CTRunGetAttributes(run);
            UIImage *image = [runAttributed objectForKey:@"TheImage"];
            
            if (image) {
                CGFloat runAsent;
                CGFloat runDescent;
                CGPoint origin = origins[lineIndex];
                CGRect runRect;
                
                runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &runAsent, &runDescent, NULL);
                CGFloat offset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                runRect = CGRectMake(origin.x + offset, origin.y - runDescent, runRect.size.width, runAsent + runDescent);
                
                CGContextDrawImage(context, runRect, image.CGImage);
            }
        }
        
        CGPoint origin = origins[lineIndex];
        CGPoint points[2];
        points[0] = origin;
        points[1] = CGPointMake(origin.x + drawSize.width, origin.y);
        CGContextAddLines(context, points, 2);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    self.contents = (__bridge id)image.CGImage;
}

- (CoreTextRunRange)runRangeForPoint:(CGPoint)point
{
    point = CGPointMake(point.x, self.bounds.size.height - point.y);
    
    CFArrayRef lineArray = CTFrameGetLines(self.frameRef);
    CGPoint originArray[CFArrayGetCount(lineArray)];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), originArray);
    
    //获取点击所在行
    //origins格式为[{0, 100}, {0, 80}]，原因为坐标系在左下角，且该点位该行基点坐标
    //寻找点击点位于哪个范围内
    NSInteger pointRangeIndex = (NSInteger)CFArrayGetCount(lineArray);
    while (pointRangeIndex > 0) {
        CGPoint origin = originArray[pointRangeIndex - 1];
        if (origin.y > point.y) {
            break;
        }
        pointRangeIndex--;
    }
    
    //获取所点击的run
    //首先判断大概率的上部
    NSInteger pointLineIndex = NSNotFound;
    NSInteger pointRunIndex = NSNotFound;
    if (pointRangeIndex < CFArrayGetCount(lineArray)) {
        pointRunIndex = [self runIndexForPoint:point atLine:pointRangeIndex line:CFArrayGetValueAtIndex(lineArray, pointRangeIndex) originArray:originArray];
        if (pointRunIndex != NSNotFound) {
            pointLineIndex = pointRangeIndex;
        }
    }
    //再判断小概率的下部
    if (pointLineIndex == NSNotFound &&
        pointRunIndex == NSNotFound &&
        pointRangeIndex > 0) {
        pointRunIndex = [self runIndexForPoint:point atLine:pointRangeIndex - 1 line:CFArrayGetValueAtIndex(lineArray, pointRangeIndex - 1) originArray:originArray];
        if (pointRunIndex != NSNotFound) {
            pointLineIndex = pointRangeIndex - 1;
        }
    }
    
    if (pointLineIndex != NSNotFound &&
        pointRunIndex != NSNotFound) {
        CTLineRef line = CFArrayGetValueAtIndex(lineArray, pointLineIndex);
        CFArrayRef runArray = CTLineGetGlyphRuns(line);
        CTRunRef run = CFArrayGetValueAtIndex(runArray, pointRunIndex);
        NSDictionary *attributedDic = (__bridge NSDictionary *)CTRunGetAttributes(run);
        if ([attributedDic objectForKey:@"TheImage"]) {
            NSLog(@"点击了图片");
        } else {
            CFRange cfRange = CTRunGetStringRange(run);
            NSRange range = NSMakeRange(cfRange.location, cfRange.length);
            NSString *string = [self.originalAttributedString.string substringWithRange:range];
            NSLog(@"-->%@", string);
        }
        
    }
    
    CoreTextRunRange runRange;
    runRange.lineIndex = pointLineIndex;
    runRange.runIndex = pointRunIndex;
    return runRange;
}

- (NSInteger)runIndexForPoint:(CGPoint)point atLine:(NSInteger)lineIndex line:(CTLineRef)line originArray:(CGPoint *)originArray
{
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (NSInteger runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = CFArrayGetValueAtIndex(runArray, runIndex);
        
        CGFloat runAsent, runDescent;
        CGPoint origin = originArray[lineIndex];
        CGRect runRect;
        
        runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &runAsent, &runDescent, NULL);
        CGFloat offset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
        runRect = CGRectMake(origin.x + offset, origin.y - runDescent, runRect.size.width, runAsent + runDescent);
        
        if (point.x > CGRectGetMinX(runRect) &&
            point.x < CGRectGetMaxX(runRect) &&
            point.y > CGRectGetMinY(runRect) &&
            point.y < CGRectGetMaxY(runRect)) {
            return runIndex;
        }
    }
    return NSNotFound;
}

- (void)dealloc
{
    if (self.frameRef) {
        CFRelease(self.frameRef);
    }
}

@end
