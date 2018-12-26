//
//  CoreTextView.m
//  Valhalla
//
//  Created by mademao on 2018/12/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import "CoreTextView.h"
#import "CoreTextLayer.h"

@implementation CoreTextView

+ (Class)layerClass
{
    return [CoreTextLayer class];
}

- (void)setFrame:(CGRect)frame
{
    CGRect oldFrame = self.frame;
    [super setFrame:frame];
    CGRect newFrame = self.frame;
    if (CGRectEqualToRect(oldFrame, newFrame) == NO) {
        [self loadView];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CoreTextLayer *layer = (CoreTextLayer *)self.layer;
    CoreTextRunRange runRange = [layer runRangeForPoint:point];
    if (runRange.lineIndex != NSNotFound &&
        runRange.runIndex != NSNotFound) {
        NSLog(@"点击点位于第%@行，第%@个run", @(runRange.lineIndex), @(runRange.runIndex));
    } else {
        NSLog(@"点击点处没有富文本");
    }
}

- (void)loadView
{
    [self.layer setNeedsDisplay];
}

@end
