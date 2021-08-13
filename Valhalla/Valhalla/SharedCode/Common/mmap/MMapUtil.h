//
//  MMapUtil.h
//  Valhalla
//
//  Created by mademao on 2021/7/29.
//  Copyright © 2021 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMapUtil : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath
                        readonly:(BOOL)readonly;

- (void)write:(NSString *)value;

- (NSString *)read;

@end

NS_ASSUME_NONNULL_END
