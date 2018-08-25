//
//  WaterLayout.h
//  WaterFlowLayoutDemo
//
//  Created by 马德茂 on 16/6/3.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterflowLayout;

@protocol WaterflowLayoutDelegate <NSObject>

@required
/**
 *  计算item的高度
 */
- (CGFloat)waterflowLayout:(WaterflowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@optional
/**
 *  提供瀑布流的列数
 */
- (NSUInteger)columnOfWaterflowLayout:(WaterflowLayout *)waterflowLayout;
/**
 *  提供瀑布流列之间间隔
 */
- (CGFloat)spaceForColumnOfWaterflowLayout:(WaterflowLayout *)waterflowLayout;
/**
 *  提供瀑布流行之间间隔
 */
- (CGFloat)spaceForRowOfWaterflowLayout:(WaterflowLayout *)waterflowLayout;
/**
 *  提供瀑布流四周边缘间隔
 */
- (UIEdgeInsets)edgeInsetsOfWaterflowLayout:(WaterflowLayout *)waterflowLayout;

@end

@interface WaterflowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WaterflowLayoutDelegate> delegate;

- (instancetype)initWithDelegate:(id<WaterflowLayoutDelegate>)delegate;

@end
