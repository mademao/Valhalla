//
//  LeftJustifyLayout.h
//  LeftJustifyLayoutExample
//
//  Created by Pluto on 2017/5/26.
//  Copyright © 2017年 Pluto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeftJustifyLayout;

@protocol LeftJustifyLayoutDelegate <NSObject>
@required
///collectionView上下左右的内偏移量
- (UIEdgeInsets)edgeInsetsOfLayout:(LeftJustifyLayout *)layout;
///每一行的高度
- (CGFloat)heightForRowOfLayout:(LeftJustifyLayout *)layout;
///每一行两个块之间的间隔
- (CGFloat)spaceForControlOfLayout:(LeftJustifyLayout *)layout;
///每两行之间的间隔
- (CGFloat)spaceForLineOfLayout:(LeftJustifyLayout *)layout;
///collectionView最大支持的行数
- (NSUInteger)maxRowOfLayout:(LeftJustifyLayout *)layout;
///每一块的宽度
- (CGFloat)layout:(LeftJustifyLayout *)layout widthForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface LeftJustifyLayout : UICollectionViewFlowLayout
- (instancetype)initWithDelegate:(id<LeftJustifyLayoutDelegate>)delegate;
@end
