//
//  WaterflowLayoutViewController.m
//  Valhalla
//
//  Created by 马德茂 on 2018/8/25.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "WaterflowLayoutViewController.h"
#import "WaterflowLayout.h"

@interface WaterflowCell : UICollectionViewCell

@end

@implementation WaterflowCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor greenColor];
    }
    return self;
}

@end


@interface WaterflowLayoutViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WaterflowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation WaterflowLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
}

- (void)setUpUI
{
    
    WaterflowLayout *layout = [[WaterflowLayout alloc] init];
    layout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[WaterflowCell class] forCellWithReuseIdentifier:NSStringFromClass([WaterflowCell class])];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaterflowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WaterflowCell class]) forIndexPath:indexPath];
    return cell;
}

- (CGFloat)waterflowLayout:(WaterflowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    CGSize size = [[self.dataArray objectAtIndex:indexPath.item] CGSizeValue];
    return itemWidth * (double)size.height / size.width;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
        
        for (int i = 0; i < 1000; i++) {
            int width = arc4random() % 30 + 100;
            int height = arc4random() % 100 + 150;
            CGSize size = CGSizeMake(width, height);
            [self.dataArray addObject:[NSValue valueWithCGSize:size]];
        }
        
    }
    return _dataArray;
}

@end
