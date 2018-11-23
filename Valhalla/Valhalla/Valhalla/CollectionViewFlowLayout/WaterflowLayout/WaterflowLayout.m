//
//  WaterLayout.m
//  WaterFlowLayoutDemo
//
//  Created by 马德茂 on 16/6/3.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import "WaterflowLayout.h"

/** 默认高度 */
static const CGFloat kDefaultHeight = 100;

/** 默认的列数 */
static const NSUInteger kDefaultColumn = 4;
/** 默认每一列之间的间距 */
static const CGFloat kDefaultColumnSpace = 10;
/** 默认每一行之间的间距 */
static const CGFloat kDefaultRowSpace = 10;
/** 默认边缘间距 */
static const UIEdgeInsets kDefaultEdgeInsets = {10, 10, 10, 10};

@interface WaterflowLayout ()
/** 列数 */
@property (nonatomic, assign) NSUInteger column;
/** 列间距 */
@property (nonatomic, assign) CGFloat columnSpace;
/** 行间距 */
@property (nonatomic, assign) CGFloat rowSpace;
/** 边距 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/** 所有item布局属性 */
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributeArray;
/** 各列高度 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnHeights;
/** 内容高度(不包含底边距) */
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, assign) CGRect lastBounds;
@end

@implementation WaterflowLayout

- (instancetype)initWithDelegate:(id<WaterflowLayoutDelegate>)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    [self.columnHeights removeAllObjects];
    for (int index = 0; index < self.column; index++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    [self.attributeArray removeAllObjects];
    for (int index = 0; index < [self.collectionView numberOfItemsInSection:0]; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributeArray addObject:attributes];
    }
    self.lastBounds = self.collectionView.bounds;
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributeArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 宽度
    CGFloat width = (self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right - (self.column - 1) * self.columnSpace) / self.column;
    // 高度
    CGFloat height = kDefaultHeight;
    if (self.delegate && [self.delegate respondsToSelector:@selector(waterflowLayout:heightForItemAtIndexPath:itemWidth:)]) {
        height = [self.delegate waterflowLayout:self heightForItemAtIndexPath:indexPath itemWidth:width];
    }
    
    // 计算应当处于的列数
    NSUInteger minLengthColum = 0;
    for (int index = 0; index < self.column; index++) {
        if ([self.columnHeights[index] floatValue] < [self.columnHeights[minLengthColum] floatValue]) {
            minLengthColum = index;
        }
    }
    
    // X坐标
    CGFloat x = self.edgeInsets.left + minLengthColum * (width + self.columnSpace);
    
    // Y坐标
    CGFloat y = [self.columnHeights[minLengthColum] floatValue];
    if (y != self.edgeInsets.top) {
        y += self.rowSpace;
    }
    
    attributes.frame = CGRectMake(x, y, width, height);
    
    // 更新记录
    self.columnHeights[minLengthColum] = @(CGRectGetMaxY(attributes.frame));
    self.contentHeight = [self.columnHeights[minLengthColum] floatValue];
    for (NSNumber *height in self.columnHeights) {
        CGFloat theHeight = [height floatValue];
        if (theHeight > self.contentHeight) {
            self.contentHeight = theHeight;
        }
    }
    
    return attributes;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight + self.edgeInsets.bottom);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (CGSizeEqualToSize(newBounds.size, self.lastBounds.size)) {
        return NO;
    } else {
        self.lastBounds = newBounds;
        return YES;
    }
}

#pragma mark - 懒加载
- (NSUInteger)column
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(columnOfWaterflowLayout:)]) {
        return [self.delegate columnOfWaterflowLayout:self];
    } else {
        return kDefaultColumn;
    }
}

- (CGFloat)columnSpace
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(spaceForColumnOfWaterflowLayout:)]) {
        return [self.delegate spaceForColumnOfWaterflowLayout:self];
    } else {
        return kDefaultColumnSpace;
    }
}

- (CGFloat)rowSpace
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(spaceForRowOfWaterflowLayout:)]) {
        return [self.delegate spaceForRowOfWaterflowLayout:self];
    } else {
        return kDefaultRowSpace;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(edgeInsetsOfWaterflowLayout:)]) {
        return [self.delegate edgeInsetsOfWaterflowLayout:self];
    } else {
        return kDefaultEdgeInsets;
    }
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attributeArray
{
    if (_attributeArray == nil) {
        _attributeArray = [NSMutableArray array];
    }
    return _attributeArray;
}

- (NSMutableArray<NSNumber *> *)columnHeights
{
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

@end
