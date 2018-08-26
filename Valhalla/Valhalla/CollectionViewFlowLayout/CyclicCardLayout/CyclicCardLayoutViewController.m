//
//  CyclicCardLayoutViewController.m
//  Valhalla
//
//  Created by 马德茂 on 2018/8/25.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "CyclicCardLayoutViewController.h"
#import "CyclicCardLayout.h"

@interface CyclicCardLayoutViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<NSString *> *dataArray;
//此处有循环引用
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CyclicCardLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = @[@"1", @"2", @"3", @"4"];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    CGFloat offset = 20.0f;
    CGFloat collectionViewHeight = 100.0f;
    
    CyclicCardLayout *layout = [[CyclicCardLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = offset;
    layout.minimumInteritemSpacing = offset;
    layout.itemSize = CGSizeMake((size.width - 2 * offset) / 2.0, collectionViewHeight - 2 * offset);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, size.width, collectionViewHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count * 50 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self beginTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer];
}

- (void)beginTimer {
    [self stopTimer];
    self.timer = [NSTimer timerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        //首先 切换至最中间一组，然后再滚动到下一张，避免长时间滚动造成滚动到最后一张
        CGPoint pointInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointInView];
        NSIndexPath *beginIndexPath = [NSIndexPath indexPathForItem:indexPath.item % self.dataArray.count + self.dataArray.count * 50 inSection:indexPath.section];
        [self.collectionView scrollToItemAtIndexPath:beginIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:beginIndexPath.item + 1 inSection:beginIndexPath.section];
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count * 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:11111];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:23];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 11111;
        [cell.contentView addSubview:label];
    }
    label.text = [self.dataArray objectAtIndex:indexPath.item % self.dataArray.count];
    cell.backgroundColor = [self getRadomColor];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //开始拖拽时 停止timer，避免拖拽时间过长造成的停止拖拽瞬间滚动到下一张
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每次拖拽完成后，自动重置到中间一组，避免多次拖拽造成滚动到最后一张
    CGPoint pointInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointInView];
    NSIndexPath *beginIndexPath = [NSIndexPath indexPathForItem:indexPath.item % self.dataArray.count + self.dataArray.count * 50 inSection:indexPath.section];
    [self.collectionView scrollToItemAtIndexPath:beginIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    //拖拽完成后，重启自动滚动
    [self beginTimer];
}


- (UIColor *)getRadomColor {
    CGFloat r = random() % 255;
    CGFloat g = random() % 255;
    CGFloat b = random() % 255;
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}

@end
