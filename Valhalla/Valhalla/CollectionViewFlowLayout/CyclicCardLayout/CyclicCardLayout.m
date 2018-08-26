//
//  PlutoCyclicCardLayout.m
//  CyclicCardDemo
//
//  Created by Dareway on 2017/5/3.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

#import "CyclicCardLayout.h"

@implementation CyclicCardLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat offset = self.collectionView.frame.size.width - self.itemSize.width;
    offset = offset / 2.0;
    self.sectionInset = UIEdgeInsetsMake(0, offset, 0, offset);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect currentContentRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    NSArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [self layoutAttributesForElementsInRect:currentContentRect];
    CGFloat adjustOffset = CGFLOAT_MAX;
    CGFloat centerX = currentContentRect.origin.x + currentContentRect.size.width / 2.0;
    for (UICollectionViewLayoutAttributes *attribute in layoutAttributes) {
        if (fabs(attribute.center.x - centerX) < fabs(adjustOffset)) {
            adjustOffset = attribute.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + adjustOffset, proposedContentOffset.y);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *layoutAttributesCopy = [NSMutableArray arrayWithCapacity:layoutAttributes.count];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    for (UICollectionViewLayoutAttributes *attribute in layoutAttributes) {
        UICollectionViewLayoutAttributes *attributeCopy = [attribute copy];
        CGFloat distance = visibleRect.origin.x + visibleRect.size.width / 2.0 - attributeCopy.center.x;
        CGFloat normalizedDistance = fabs(distance / 400);
        CGFloat zoom = 1 - 0.75 * normalizedDistance;
        attributeCopy.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0);
        attributeCopy.zIndex = 1;
        [layoutAttributesCopy addObject:attributeCopy];
    }
    return layoutAttributesCopy;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
