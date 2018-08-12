//
//  MDMSectionModel.h
//  Valhalla
//
//  Created by 马德茂 on 2018/8/11.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMRowModel.h"

@interface MDMSectionModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray<MDMRowModel *> *rowModelArray;

@end
