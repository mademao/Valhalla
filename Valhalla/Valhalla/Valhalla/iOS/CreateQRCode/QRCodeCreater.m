//
//  QRCodeCreater.m
//  Valhalla
//
//  Created by mademao on 2018/9/21.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "QRCodeCreater.h"
#import <CoreImage/CoreImage.h>

@implementation QRCodeCreater

+ (UIImage *)createQRCodeWithContent:(NSString *)content imageLength:(CGFloat)imageLength {
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换为数据
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获取滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withLength:imageLength];
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withLength:(CGFloat)length {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(length / CGRectGetWidth(extent), length / CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpace);
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return outputImage;
}
@end
