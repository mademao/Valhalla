//
//  MDMSectionModel.m
//  Valhalla
//
//  Created by 马德茂 on 2018/8/11.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "MDMSectionModel.h"

@implementation MDMSectionModel

- (NSMutableArray<MDMRowModel *> *)rowModelArray {
    if (!_rowModelArray) {
        _rowModelArray = [NSMutableArray array];
    }
    return _rowModelArray;
}

@end
