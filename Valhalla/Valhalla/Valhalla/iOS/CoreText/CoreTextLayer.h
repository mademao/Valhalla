//
//  CoreTextLayer.h
//  Valhalla
//
//  Created by mademao on 2018/12/26.
//  Copyright © 2018 mademao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

///CoreText中范围表示，lineIndex表示所在行，runIndex表示所在行中run的位置
typedef struct CoreTextRunRange {
    NSInteger lineIndex;
    NSInteger runIndex;
} CoreTextRunRange;

@interface CoreTextLayer : CALayer

/**
 获取点击点所对应的范围
 @param point 点击点
 @return 所在范围
 */
- (CoreTextRunRange)runRangeForPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
