//
//  FormTableView.m
//  FormTableView-Demo
//
//  Created by 马德茂 on 16/5/26.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import "FormTableView.h"
#import "FormScrollLabel.h"

/** 默认左侧宽度 */
#define FormTBLeftWidth (100)
/** 默认右侧每列宽度 */
#define FormTBRightColumnWidth (80)
/** 默认行高 */
#define FormTBRowHeight (50)


/**
 *  左侧cell
 */
@interface FormLeftCell : UITableViewCell
@property (nonatomic, copy) NSString *theTitle;
@end

@interface FormLeftCell ()
@property (nonatomic, strong) UILabel *theTitleLabel;
@end
@implementation FormLeftCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.theTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.frame.size.height)];
        [self.contentView addSubview:self.theTitleLabel];
        self.backgroundColor = [UIColor grayColor];
        self.contentView.backgroundColor = [UIColor grayColor];
        self.theTitleLabel.backgroundColor = [UIColor grayColor];
        self.theTitleLabel.textColor = [UIColor whiteColor];
        self.theTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.theTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.theTitleLabel.font = [UIFont systemFontOfSize:15];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.75, self.frame.size.width, 0.75)];
        view.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:view];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.theTitleLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.frame.size.height);
}

- (void)setTheTitle:(NSString *)theTitle
{
    self.theTitleLabel.text = theTitle;
}
@end

/**
 *  右侧cell
 */
@interface FormRightCell : UITableViewCell
- (void)setUIWithTitles:(NSArray<NSString *> *)titles widths:(NSArray<NSNumber *> *)widths;
@end

@interface FormRightCell ()
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic, copy) NSArray<NSNumber *> *widths;
@end

@implementation FormRightCell
- (void)setUIWithTitles:(NSArray<NSString *> *)titles widths:(NSArray<NSNumber *> *)widths
{
    self.titles = titles;
    self.widths = widths;
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat currentWidth = 0;
    for (int colomn = 0; colomn < self.titles.count; colomn++) {
        FormScrollLabel *label = [[FormScrollLabel alloc] initWithFrame:CGRectMake(currentWidth, 0, self.widths[colomn].floatValue, self.frame.size.height)];
        [self.contentView addSubview:label];
        label.title = self.titles[colomn];
        self.backgroundColor = [UIColor grayColor];
        self.contentView.backgroundColor = [UIColor grayColor];
        currentWidth += self.widths[colomn].floatValue;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.75, self.frame.size.width, 0.75)];
    view.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:view];
}


@end

@interface FormTableView ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

/**
 *  左侧视图
 */
@property (nonatomic, strong) UITableView *rightTableView;
/**
 *  右侧视图
 */
@property (nonatomic, strong) UITableView *leftTableView;
/**
 *  右侧滚动视图
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  左上视图
 */
@property (nonatomic, strong) UIView *leftView;
/**
 *  右上视图
 */
@property (nonatomic, strong) UIView *rightView;

/** 左侧宽度 */
@property (nonatomic, assign) CGFloat leftWidth;
/** 右侧宽度数组 */
@property (nonatomic, copy) NSArray<NSNumber *> *rigthWidths;
/** 右侧宽度 */
@property (nonatomic, assign) CGFloat rightWidth;
/** 行高 */
@property (nonatomic, assign) CGFloat rowHeight;

@end

@implementation FormTableView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FormTableViewDelegate>)delegate dataSource:(id<FormTableViewDataSource>)dataSource
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.dataSource = dataSource;
        
        [self reloadData];
    }
    return self;
}

- (void)reloadData
{
    [self.leftTableView removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self.rightTableView removeFromSuperview];
    [self initData];
    [self setUpUI];
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}


/**
 *  初始化数据
 */
- (void)initData
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(widthForLeftInFormTableView:)]) {
        self.leftWidth = [self.delegate widthForLeftInFormTableView:self];
    } else {
        self.leftWidth = FormTBLeftWidth;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(formTableView:widthForRightAtColumn:)]) {
        self.rightWidth = 0;
        NSMutableArray *rightWidthsTemp = [NSMutableArray array];
        for (int column = 0; column < [self.dataSource numberOfColumnsInFormTableView:self]; column++) {
            self.rightWidth += [self.delegate formTableView:self widthForRightAtColumn:column];
            [rightWidthsTemp addObject:[NSNumber numberWithDouble:[self.delegate formTableView:self widthForRightAtColumn:column]]];
        }
        self.rigthWidths = [rightWidthsTemp copy];
    } else {
        self.rightWidth = FormTBRightColumnWidth * [self.dataSource numberOfColumnsInFormTableView:self];
        NSMutableArray *rightWidthsTemp = [NSMutableArray array];
        for (int column = 0; column < [self.dataSource numberOfColumnsInFormTableView:self]; column++) {
            [rightWidthsTemp addObject:[NSNumber numberWithDouble:FormTBRightColumnWidth]];
        }
        self.rigthWidths = [rightWidthsTemp copy];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForRowInFormTableView:)]) {
        self.rowHeight = [self.delegate heightForRowInFormTableView:self];
    } else {
        self.rowHeight = FormTBRowHeight;
    }
}

/**
 *  布局视图
 */
- (void)setUpUI
{
    if (self.leftTableView) {
        [self.leftTableView removeFromSuperview];
    }
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.rowHeight, self.leftWidth, self.frame.size.height - self.rowHeight) style:UITableViewStylePlain];
    [self addSubview:self.leftTableView];
    self.leftTableView.showsHorizontalScrollIndicator = NO;
    self.leftTableView.showsVerticalScrollIndicator = NO;
    self.leftTableView.bounces = NO;
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.leftTableView registerClass:[FormLeftCell class] forCellReuseIdentifier:NSStringFromClass([FormLeftCell class])];
    
    if (self.scrollView) {
        [self.scrollView removeFromSuperview];
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.leftWidth, 0, self.frame.size.width - self.leftWidth, self.frame.size.height)];
    [self addSubview:self.scrollView];
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(self.rightWidth, self.frame.size.height);
    
    if (self.rightTableView) {
        [self.rightTableView removeFromSuperview];
    }
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.rowHeight, self.rightWidth, self.frame.size.height - self.rowHeight)];
    [self.scrollView addSubview:self.rightTableView];
    self.rightTableView.showsVerticalScrollIndicator = NO;
    self.rightTableView.showsHorizontalScrollIndicator = NO;
    self.rightTableView.bounces = NO;
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightTableView registerClass:[FormRightCell class] forCellReuseIdentifier:NSStringFromClass([FormRightCell class])];
    
    if (self.leftView) {
        [self.leftView removeFromSuperview];
    }
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leftWidth, self.rowHeight)];
    [self addSubview:self.leftView];
    self.leftView.backgroundColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.leftWidth, self.rowHeight)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [self.leftView addSubview:label];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(titleForLeftColumnInFormTableView:)]) {
        label.text = [self.dataSource titleForLeftColumnInFormTableView:self];
    }
    
    if (self.rightView) {
        [self.rightView removeFromSuperview];
    }
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rightWidth, self.rowHeight)];
    [self.scrollView addSubview:self.rightView];
    self.rightView.backgroundColor = [UIColor blackColor];
    CGFloat currentWidth = 0;
    for (int colomn = 0; colomn < self.rigthWidths.count; colomn++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(currentWidth, 0, self.rigthWidths[colomn].floatValue, self.rowHeight)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [self.rightView addSubview:label];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(formTableView:titleForColumnAtIndex:)]) {
            label.text = [self.dataSource formTableView:self titleForColumnAtIndex:colomn];
        }
        currentWidth += self.rigthWidths[colomn].floatValue;
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfColumnsInFormTableView:)]) {
        return [self.dataSource numberOfRowsInFormTableView:self];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(formTableView:titleForLeftBlockAtIndex:)] && [self.dataSource respondsToSelector:@selector(formTableView:titleForRightBlockAtRow:column:)]) {
        if (tableView == self.leftTableView) {
            FormLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FormLeftCell class]) forIndexPath:indexPath];
            cell.theTitle = [self.dataSource formTableView:self titleForLeftBlockAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (tableView == self.rightTableView) {
            FormRightCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FormRightCell class]) forIndexPath:indexPath];
            NSMutableArray<NSString *> *arrayTemp = [NSMutableArray array];
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(formTableView:titleForRightBlockAtRow:column:)]) {
                for (int colomn = 0; colomn < self.rigthWidths.count; colomn++) {
                    NSString *string = [self.dataSource formTableView:self titleForRightBlockAtRow:indexPath.row column:colomn];
                    [arrayTemp addObject:string];
                }
            }
            [cell setUIWithTitles:arrayTemp widths:self.rigthWidths];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.leftTableView == scrollView) {
        self.rightTableView.contentOffset = CGPointMake(self.rightTableView.contentOffset.x, self.leftTableView.contentOffset.y);
    } else if (self.rightTableView == scrollView) {
        self.leftTableView.contentOffset = CGPointMake(self.leftTableView.contentOffset.x, self.rightTableView.contentOffset.y);
    }
}

@end
