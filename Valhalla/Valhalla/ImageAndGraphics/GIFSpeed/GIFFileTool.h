//
//  GIFFileTool.h
//  Valhalla
//
//  Created by mademao on 2018/8/13.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GIFChangeSpeedTypeMultiple,
    GIFChangeSpeedTypeValue
} GIFChangeSpeedType;

@interface GIFFileTool : NSObject

/**
 修改源文件调整GIF帧间距
 @param gifFilePath GIF所在路径
 @param changeSpeedType 调整方式
 @param value 若为multiple方式，则是原先的倍数；若为value方式，则是帧间隔，单位s
 
 @return 调整结果
 */
+ (BOOL)changeGIFSpeedWithGIFFilePath:(NSString *)gifFilePath changeSpeedType:(GIFChangeSpeedType)changeSpeedType value:(CGFloat)value;

@end
