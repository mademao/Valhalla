//
//  CompressImageUtil.h
//  Valhalla
//
//  Created by mademao on 2019/7/1.
//  Copyright © 2019 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CompressImageUtil : NSObject

/**
 根据图片宽高限制压缩图片
 @param imageData   待压缩图片数据
 @param compressImagePath   压缩后图片写入文件
 @param maxLength   图片宽高限制
 @return 是否压缩成功
 */
+ (BOOL)compressionImageWithImageData:(NSData *)imageData compressImagePath:(NSString *)compressImagePath maxLength:(NSInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
