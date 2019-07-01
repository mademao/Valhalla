//
//  CompressImageUtil.m
//  Valhalla
//
//  Created by mademao on 2019/7/1.
//  Copyright © 2019 mademao. All rights reserved.
//

#import "CompressImageUtil.h"
#import <YYImage/YYImage.h>
#import <CoreServices/CoreServices.h>

@implementation CompressImageUtil

///根据图片宽高限制压缩图片
+ (BOOL)compressionImageWithImageData:(NSData *)imageData compressImagePath:(NSString *)compressImagePath maxLength:(NSInteger)maxLength
{
    if (compressImagePath.length == 0) {
        return NO;
    }
    
    YYImageType imageType = YYImageDetectType((__bridge CFDataRef)imageData);
    
    if (imageType == YYImageTypeJPEG ||
        imageType == YYImageTypeJPEG2000 ||
        imageType == YYImageTypePNG) {
        NSDictionary *imageSourceOption = @{(NSString *)kCGImageSourceShouldCache : [NSNumber numberWithBool:NO]};
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, (__bridge CFDictionaryRef)imageSourceOption);
        if (imageSource == NULL) {
            return NO;
        }
        
        size_t imageCount = CGImageSourceGetCount(imageSource);
        if (imageCount == 0) {
            CFRelease(imageSource);
            return NO;
        }
        
        CFDictionaryRef frameProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil);
        if (frameProperties == NULL) {
            CFRelease(imageSource);
            return NO;
        }
        
        NSInteger width = 0, height = 0;
        CFTypeRef value = NULL;
        value = CFDictionaryGetValue(frameProperties, kCGImagePropertyPixelWidth);
        if (value) CFNumberGetValue(value, kCFNumberNSIntegerType, &width);
        value = CFDictionaryGetValue(frameProperties, kCGImagePropertyPixelHeight);
        if (value) CFNumberGetValue(value, kCFNumberNSIntegerType, &height);
        CFRelease(frameProperties);
        if (width <= maxLength &&
            height <= maxLength) {
            CFRelease(imageSource);
            return YES;
        }
        
        //读取图片
        NSDictionary *thumbnailOption = @{
                                          (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : [NSNumber numberWithBool:YES],
                                          (NSString *)kCGImageSourceCreateThumbnailWithTransform : [NSNumber numberWithBool:YES],
                                          (NSString *)kCGImageSourceShouldCacheImmediately : [NSNumber numberWithBool:YES],
                                          (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInteger:maxLength]
                                          };
        CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (__bridge CFDictionaryRef)thumbnailOption);
        if (imageRef == NULL) {
            CFRelease(imageSource);
            return NO;
        }
        
        //写入图片
        NSURL *imageDestinationUrl = [NSURL fileURLWithPath:compressImagePath];
        CFStringRef typeStringRef = NULL;
        if (imageType == YYImageTypeJPEG) {
            typeStringRef = kUTTypeJPEG;
        } else if (imageType == YYImageTypeJPEG2000) {
            typeStringRef = kUTTypeJPEG2000;
        } else {
            typeStringRef = kUTTypePNG;
        }
        CGImageDestinationRef imageDestinationRef = CGImageDestinationCreateWithURL((__bridge CFURLRef)imageDestinationUrl, typeStringRef, 1, NULL);
        if (imageDestinationRef == NULL) {
            CFRelease(imageSource);
            CGImageRelease(imageRef);
            return NO;
        }
        CGImageDestinationAddImage(imageDestinationRef, imageRef, NULL);
        
        BOOL result = CGImageDestinationFinalize(imageDestinationRef);
        
        CGImageRelease(imageRef);
        CFRelease(imageSource);
        CFRelease(imageDestinationRef);
        
        return result;
    } else if (imageType == YYImageTypeGIF) {
        NSDictionary *imageSourceOption = @{(NSString *)kCGImageSourceShouldCache : [NSNumber numberWithBool:NO]};
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(imageData), (__bridge CFDictionaryRef)imageSourceOption);
        if (imageSource == NULL) {
            return NO;
        }
        
        size_t imageCount = CGImageSourceGetCount(imageSource);
        if (imageCount == 0) {
            CFRelease(imageSource);
            return NO;
        }
        
        CFDictionaryRef frameProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil);
        if (frameProperties == NULL) {
            CFRelease(imageSource);
            return NO;
        }
        NSInteger width = 0, height = 0;
        CFTypeRef value = NULL;
        value = CFDictionaryGetValue(frameProperties, kCGImagePropertyPixelWidth);
        if (value) CFNumberGetValue(value, kCFNumberNSIntegerType, &width);
        value = CFDictionaryGetValue(frameProperties, kCGImagePropertyPixelHeight);
        if (value) CFNumberGetValue(value, kCFNumberNSIntegerType, &height);
        CFRelease(frameProperties);
        if (width <= maxLength &&
            height <= maxLength) {
            CFRelease(imageSource);
            return YES;
        }
        
        NSInteger loopCount = 0;
        CFDictionaryRef properties = CGImageSourceCopyProperties(imageSource, NULL);
        if (properties) {
            CFDictionaryRef gif = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
            if (gif) {
                CFTypeRef loop = CFDictionaryGetValue(gif, kCGImagePropertyGIFLoopCount);
                if (loop) CFNumberGetValue(loop, kCFNumberNSIntegerType, &loopCount);
            }
            CFRelease(properties);
        }
        
        NSURL *imageDestinationUrl = [NSURL fileURLWithPath:compressImagePath];
        CGImageDestinationRef imageDestinationRef = CGImageDestinationCreateWithURL((__bridge CFURLRef)imageDestinationUrl, kUTTypeGIF, imageCount, NULL);
        if (imageDestinationRef == NULL) {
            CFRelease(imageSource);
            return NO;
        }
        NSDictionary *destinationGifProperties = @{(NSString *)kCGImagePropertyGIFHasGlobalColorMap : [NSNumber numberWithBool:YES],
                                                   (NSString *)kCGImagePropertyGIFLoopCount : [NSNumber numberWithInteger:loopCount]};
        NSDictionary *destinationProperties = @{(NSString *)kCGImagePropertyGIFDictionary : destinationGifProperties};
        CGImageDestinationSetProperties(imageDestinationRef, (__bridge CFDictionaryRef)destinationProperties);
        
        for (int i = 0; i < imageCount; i++) {
            //读取帧间隔
            CFDictionaryRef cFrameProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil);
            NSDictionary *frameProperties = (__bridge NSDictionary *)cFrameProperties;
            NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            if (delayTimeUnclampedProp == nil) {
                delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
                if (delayTimeUnclampedProp == nil) {
                    delayTimeUnclampedProp = [NSNumber numberWithDouble:0.000001];
                }
            }
            if (cFrameProperties) {
                CFRelease(cFrameProperties);
            }
            //读取图片
            NSDictionary *thumbnailOption = @{
                                              (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : [NSNumber numberWithBool:YES],
                                              (NSString *)kCGImageSourceCreateThumbnailWithTransform : [NSNumber numberWithBool:YES],
                                              (NSString *)kCGImageSourceShouldCacheImmediately : [NSNumber numberWithBool:YES],
                                              (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInteger:maxLength]
                                              };
            CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(imageSource, i, (__bridge CFDictionaryRef)thumbnailOption);
            if (imageRef == NULL) {
                CFRelease(imageSource);
                CFRelease(imageDestinationRef);
                return NO;
            }
            
            //写入图片
            NSDictionary *frameProperty = @{
                                            (NSString *)kCGImagePropertyGIFDictionary : @{(NSString *)kCGImagePropertyGIFDelayTime : delayTimeUnclampedProp}
                                            };
            CGImageDestinationAddImage(imageDestinationRef, imageRef, (CFDictionaryRef)frameProperty);
            CFRelease(imageRef);
        }
        
        BOOL result = CGImageDestinationFinalize(imageDestinationRef);

        CFRelease(imageSource);
        CFRelease(imageDestinationRef);
        
        return result;
    }
    
    return NO;
}

@end
