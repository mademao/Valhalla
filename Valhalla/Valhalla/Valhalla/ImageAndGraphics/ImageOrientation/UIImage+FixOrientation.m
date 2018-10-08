//
//  UIImage+FixOrientation.m
//  Valhalla
//
//  Created by mademao on 2018/10/8.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "UIImage+FixOrientation.h"

@implementation UIImage (FixOrientation)

- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    size_t width = (size_t)CGImageGetWidth(self.CGImage);
    size_t height = (size_t)CGImageGetHeight(self.CGImage);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGFloat drawWidth = 0;
    CGFloat drawHeight = 0;
    switch (self.imageOrientation) {
        case UIImageOrientationDown: {
            transform = CGAffineTransformTranslate(transform, width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            
            drawWidth = width;
            drawHeight = height;
            
            break;
        }
        case UIImageOrientationLeft: {
            transform = CGAffineTransformScale(transform, (double)height / (double)width, (double)width / (double)height);
            transform = CGAffineTransformTranslate(transform, width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            drawWidth = height;
            drawHeight = width;
            
            break;
        }
        case UIImageOrientationRight: {
            transform = CGAffineTransformScale(transform, (double)height / (double)width, (double)width / (double)height);
            transform = CGAffineTransformTranslate(transform, 0, height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            
            drawWidth = height;
            drawHeight = width;
            break;
        }
        case UIImageOrientationUpMirrored: {
            transform = CGAffineTransformTranslate(transform, width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            
            drawWidth = width;
            drawHeight = height;
            break;
        }
        case UIImageOrientationDownMirrored: {
            transform = CGAffineTransformTranslate(transform, 0, height);
            transform = CGAffineTransformScale(transform, 1, -1);
            
            drawWidth = width;
            drawHeight = height;
            break;
        }
        case UIImageOrientationLeftMirrored: {
            transform = CGAffineTransformTranslate(transform, height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            transform = CGAffineTransformScale(transform, (double)height / (double)width, (double)width / (double)height);
            transform = CGAffineTransformTranslate(transform, 0, height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            
            drawWidth = height;
            drawHeight = width;
            break;
        }
        case UIImageOrientationRightMirrored: {
            transform = CGAffineTransformScale(transform, (double)height / (double)width, (double)width / (double)height);
            transform = CGAffineTransformTranslate(transform, 0, width);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            transform = CGAffineTransformTranslate(transform, width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            
            drawWidth = height;
            drawHeight = width;
            break;
        }
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, drawWidth, drawHeight, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, CGRectMake(0, 0, drawWidth, drawHeight), self.CGImage);
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg scale:self.scale orientation:UIImageOrientationUp];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
