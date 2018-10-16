//
//  ForceTouchDetailViewController.h
//  Valhalla
//
//  Created by mademao on 2018/10/16.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForceTouchDetailViewController : UIViewController

@property (nonatomic, copy) NSString *message;

///peek时上拉出来的菜单
@property (nonatomic, copy) NSArray<id<UIPreviewActionItem>> *actions;

@end

NS_ASSUME_NONNULL_END
