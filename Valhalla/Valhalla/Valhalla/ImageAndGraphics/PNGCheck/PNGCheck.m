//
//  PNGCheck.m
//  PNGCheck
//
//  Created by mademao on 2019/3/21.
//  Copyright © 2019 mademao. All rights reserved.
//

#import "PNGCheck.h"

@implementation PNGCheck

+ (void)checkPNGWithPath:(NSString *)path
{
    // 检查文件是否存在
    if (path == nil ||
        ![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return;
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    // 检查文件是否正常打开
    if (fileHandle == nil) {
        return;
    }
    
    // 检查是否为PNG
    if ([self p_checkPNG:fileHandle]) {
        BOOL finish = [self p_checkDataBlockWithFileHandle:fileHandle];
        while (finish == NO) {
            finish = [self p_checkDataBlockWithFileHandle:fileHandle];
        }
    }
}


#pragma mark - private

/// 检查是否为PNG
+ (BOOL)p_checkPNG:(NSFileHandle *)fileHandle
{
#define PNGSignatureLength 8
    if (fileHandle == nil) {
        return NO;
    }
    [fileHandle seekToFileOffset:0];
    uint8_t *pngSignature;
    size_t size;
    if ([self p_getUint8WithData:[fileHandle readDataOfLength:PNGSignatureLength] result:&pngSignature size:&size] == NO ||
        size != PNGSignatureLength) {
        return NO;
    }
    BOOL isPNG = YES;
    uint8_t standardSignature[PNGSignatureLength] = {0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a};
    for (NSUInteger i = 0; i < PNGSignatureLength; i++) {
        if (pngSignature[i] != standardSignature[i]) {
            isPNG = NO;
            break;
        }
    }
    return isPNG;
#undef PNGSignatureLength
}

/// 检测数据块
+ (BOOL)p_checkDataBlockWithFileHandle:(NSFileHandle *)fileHandle
{
#define SubBlockLength 4
    if (fileHandle == nil) {
        return YES;
    }
    
    uint8_t *subBlock;
    size_t size;
    
    // 读取长度信息
    if ([self p_getUint8WithData:[fileHandle readDataOfLength:SubBlockLength] result:&subBlock size:&size] == NO ||
        size != SubBlockLength) {
        return YES;
    }
    uint32_t length = (uint32_t)((subBlock[0] << 24) | (subBlock[1] << 16) | (subBlock[2] << 8) | subBlock[3]);
    
    // 读取chunk type code
    if ([self p_getUint8WithData:[fileHandle readDataOfLength:SubBlockLength] result:&subBlock size:&size] == NO ||
        size != SubBlockLength) {
        return YES;
    }
    NSMutableString *chunkTypeCode = [NSMutableString stringWithCapacity:4];
    for (NSUInteger i = 0; i < SubBlockLength; i++) {
        [chunkTypeCode appendString:[NSString stringWithFormat:@"%c", subBlock[i]]];
    }
    NSLog(@"%@", chunkTypeCode);
    
    if ([chunkTypeCode caseInsensitiveCompare:@"IEND"] == NSOrderedSame) {
        return YES;
    }
    
    // 跳过数据
    [fileHandle seekToFileOffset:fileHandle.offsetInFile + length];
    
    // 跳过crc
    [fileHandle seekToFileOffset:fileHandle.offsetInFile + SubBlockLength];
    
    return NO;
#undef SubBlockLength
}

/// 获取对应data的数据
+ (BOOL)p_getUint8WithData:(NSData *)data result:(uint8_t **)result size:(size_t *)size
{
    if (data.length == 0 || result == NULL) {
        return NO;
    }
    CFDataRef dataRef = (__bridge CFDataRef)data;
    const char *bytes = (char *)CFDataGetBytePtr(dataRef);
    *result = ((uint8_t *)bytes);
    *size = data.length;
    return YES;
}

@end
