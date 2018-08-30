//
//  FormTableView.h
//  FormTableView-Demo
//
//  Created by 马德茂 on 16/5/26.
//  Copyright © 2016年 马德茂. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FormTableView;

@protocol FormTableViewDelegate <NSObject>
@optional
/**
 *  表格左侧宽度
 */
- (CGFloat)widthForLeftInFormTableView:(FormTableView *)formTableView;
/**
 *  表格右侧每列宽度
 */
- (CGFloat)formTableView:(FormTableView *)formTableView widthForRightAtColumn:(NSUInteger)column;
/**
 *  表格中每一行高度
 */
- (CGFloat)heightForRowInFormTableView:(FormTableView *)formTableView;
@end

@protocol FormTableViewDataSource <NSObject>
@required
/**
 *  表格行数
 */
- (NSUInteger)numberOfRowsInFormTableView:(FormTableView *)formTableView;
/**
 *  表格右侧列数
 */
- (NSUInteger)numberOfColumnsInFormTableView:(FormTableView *)formTableView;
/**
 *  表格左侧列名
 */
- (NSString *)titleForLeftColumnInFormTableView:(FormTableView *)formTableView;
/**
 *  表格右侧对应列的列名
 */
- (NSString *)formTableView:(FormTableView *)formTableView titleForColumnAtIndex:(NSUInteger)column;
/**
 *  表格左侧对应行的数据
 */
- (NSString *)formTableView:(FormTableView *)formTableView titleForLeftBlockAtIndex:(NSUInteger)row;
/**
 *  表格右侧对应块的数据
 */
- (NSString *)formTableView:(FormTableView *)formTableView titleForRightBlockAtRow:(NSUInteger)row column:(NSUInteger)column;

@end


@interface FormTableView : UIView

/**
 *  处理交互事件
 */
@property (nonatomic, weak) id<FormTableViewDelegate> delegate;
/**
 *  提供数据
 */
@property (nonatomic, weak) id<FormTableViewDataSource> dataSource;

/**
 *  初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FormTableViewDelegate>)delegate dataSource:(id<FormTableViewDataSource>)dataSource;

- (void)reloadData;

@end
