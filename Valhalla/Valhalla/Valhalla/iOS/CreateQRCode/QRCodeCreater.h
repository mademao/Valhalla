//
//  QRCodeCreater.h
//  Valhalla
//
//  Created by mademao on 2018/9/21.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeCreater : NSObject

+ (UIImage *)createQRCodeWithContent:(NSString *)content imageLength:(CGFloat)imageLength;

@end

NS_ASSUME_NONNULL_END
