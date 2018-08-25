//
//  LeftJustifyLayout.m
//  LeftJustifyLayoutExample
//
//  Created by Pluto on 2017/5/26.
//  Copyright © 2017年 Pluto. All rights reserved.
//

#import "LeftJustifyLayout.h"

@interface LeftJustifyLayout ()
///代理
@property (nonatomic, weak) id<LeftJustifyLayoutDelegate> delegate;
///内偏移量
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
///每行高度
@property (nonatomic, assign) CGFloat rowHeight;
///块间间隔
@property (nonatomic, assign) CGFloat spaceControl;
///行间间隔
@property (nonatomic, assign) CGFloat spaceLine;
///最大行数
@property (nonatomic, assign) NSUInteger maxRow;
///当前页数
@property (nonatomic, assign) NSUInteger currentPage;
///当前行数
@property (nonatomic, assign) NSUInteger currentRow;
///当前快数
@property (nonatomic, assign) NSUInteger currentColumn;
///当前横向偏移量
@property (nonatomic, assign) NSUInteger currentOffsetX;

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributeArray;
@property (nonatomic, assign) CGSize currentSize;
@end

@implementation LeftJustifyLayout
- (instancetype)initWithDelegate:(id<LeftJustifyLayoutDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

///初始化数据
- (void)doInit {
    self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.rowHeight = 44.0f;
    self.spaceControl = 0.0f;
    self.spaceLine = 0.0f;
    self.maxRow = 3;
    self.currentPage = 0;
    self.currentRow = 0;
    self.currentColumn = -1;
    self.currentOffsetX = 0;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(edgeInsetsOfLayout:)]) {
            self.edgeInsets = [self.delegate edgeInsetsOfLayout:self];
        }
        if ([self.delegate respondsToSelector:@selector(heightForRowOfLayout:)]) {
            self.rowHeight = [self.delegate heightForRowOfLayout:self];
        }
        if ([self.delegate respondsToSelector:@selector(spaceForControlOfLayout:)]) {
            self.spaceControl = [self.delegate spaceForControlOfLayout:self];
        }
        if ([self.delegate respondsToSelector:@selector(spaceForLineOfLayout:)]) {
            self.spaceLine = [self.delegate spaceForLineOfLayout:self];
        }
        if ([self.delegate respondsToSelector:@selector(maxRowOfLayout:)]) {
            self.maxRow = [self.delegate maxRowOfLayout:self];
        }
    }
}

- (void)prepareLayout {
    [super prepareLayout];
    [self doInit];
    self.currentSize = self.collectionView.frame.size;
    
    [self.attributeArray removeAllObjects];
    for (int index = 0; index < [self.collectionView numberOfItemsInSection:0]; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributeArray addObject:attributes];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributeArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat width = [self.delegate layout:self widthForItemAtIndexPath:indexPath];
    CGFloat offset = self.currentOffsetX + self.edgeInsets.left + self.edgeInsets.right + width;
    if (self.currentColumn != -1) {
        offset = offset + self.spaceControl;
    }
    if (offset < self.collectionView.frame.size.width) {
        //在本行，啥都不做
    } else {
        //不在本行
        
        //防止宽度在整个一行都显示不下
        if (width > self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right) {
            width = self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right;
        }
        if (self.currentRow + 1 >= self.maxRow) {
            //超出本页
            self.currentPage++;
            self.currentRow = 0;
            self.currentColumn = -1;
            self.currentOffsetX = 0;
        } else {
            //不超出本页
            self.currentRow++;
            self.currentColumn = -1;
            self.currentOffsetX = 0;
        }
    }
    CGFloat offsetX = self.currentOffsetX + self.edgeInsets.left + self.collectionView.frame.size.width * self.currentPage;
    if (self.currentColumn != -1) {
        offsetX = offsetX + self.spaceControl;
    }
    CGRect rect = CGRectMake(offsetX, self.edgeInsets.top + self.currentRow * (self.spaceLine + self.rowHeight), width, self.rowHeight);
    self.currentOffsetX = self.currentOffsetX + width + self.spaceControl;
    self.currentColumn++;
    attributes.frame = rect;
    return attributes;
}

- (CGSize)collectionViewContentSize {
    //先计算collectionview大小
    [self calCollectionFrame];
    
    CGSize size = CGSizeMake(self.collectionView.frame.size.width * (self.currentPage + 1), self.collectionView.frame.size.height);
    return size;
}

- (void)calCollectionFrame {
    if (self.currentPage == 0) {
        if (self.currentRow == 0) {
            if (self.currentOffsetX == 0) {
                self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.edgeInsets.top + self.edgeInsets.bottom);
                return;
            }
        }
    }
    NSInteger row = self.currentRow;
    if (self.currentPage > 0) {
        row = self.maxRow - 1;
    }
    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.edgeInsets.top + self.edgeInsets.bottom + (row + 1) * self.rowHeight + row * self.spaceLine);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (CGSizeEqualToSize(self.currentSize, newBounds.size)) {
        return NO;
    } else {
        self.currentSize = newBounds.size;
        return YES;
    }
}


- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attributeArray {
    if (!_attributeArray) {
        _attributeArray = [NSMutableArray array];
    }
    return _attributeArray;
}

@end
