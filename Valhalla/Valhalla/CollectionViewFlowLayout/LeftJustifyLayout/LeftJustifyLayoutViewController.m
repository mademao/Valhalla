//
//  LeftJustifyLayoutViewController.m
//  Valhalla
//
//  Created by 马德茂 on 2018/8/25.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "LeftJustifyLayoutViewController.h"
#import "LeftJustifyLayout.h"

@interface LeftJustifyLayoutViewController () <LeftJustifyLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) LeftJustifyLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;

@end

@implementation LeftJustifyLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.layout = [[LeftJustifyLayout alloc] initWithDelegate:self];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 0) collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];
}

///collectionView上下左右的内偏移量
- (UIEdgeInsets)edgeInsetsOfLayout:(LeftJustifyLayout *)layout {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
///每一行的高度
- (CGFloat)heightForRowOfLayout:(LeftJustifyLayout *)layout {
    return 50;
}
///每一行两个块之间的间隔
- (CGFloat)spaceForControlOfLayout:(LeftJustifyLayout *)layout {
    return 5;
}
///每两行之间的间隔
- (CGFloat)spaceForLineOfLayout:(LeftJustifyLayout *)layout {
    return 5;
}
///collectionView最大支持的行数
- (NSUInteger)maxRowOfLayout:(LeftJustifyLayout *)layout {
    return 3;
}
///每一块的宽度
- (CGFloat)layout:(LeftJustifyLayout *)layout widthForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [self.dataArray objectAtIndex:indexPath.item];
    return [string boundingRectWithSize:CGSizeMake(10000, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:19]} context:nil].size.width + 5;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:11111];
    if (!label) {
        label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:19];
        cell.contentView.backgroundColor = [UIColor blueColor];
        label.tag = 11111;
        [cell.contentView addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    }
    label.text = [self.dataArray objectAtIndex:indexPath.item];
    return cell;
}


- (NSMutableArray<NSString *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        int count = random() % 4;
        //模拟不足3行的情况
        int flag = random() % 4;
        for (int i = 0; i < count; i++) {
            [_dataArray addObject:@"多少人"];
            [_dataArray addObject:@"曾爱慕你年轻时的容颜"];
            if (flag != 1) {
                [_dataArray addObject:@"可是谁能承受岁月无情的变迁"];
                [_dataArray addObject:@"多少人曾在你生命中"];
                [_dataArray addObject:@"来了又还"];
                [_dataArray addObject:@"可知一生有你我都陪在你身边"];
            } else {
                break;
            }
        }
    }
    return _dataArray;
}

@end
