//
//  GIFFileTool.m
//  Valhalla
//
//  Created by mademao on 2018/8/13.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "GIFFileTool.h"

@implementation GIFFileTool

/**
 修改源文件调整GIF帧间距
 https://blog.csdn.net/wzy198852/article/details/17266507
 */
+ (BOOL)changeGIFSpeedWithGIFFilePath:(NSString *)gifFilePath changeSpeedType:(GIFChangeSpeedType)changeSpeedType value:(CGFloat)value {
    //判断文件是否存在
    if (gifFilePath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:gifFilePath]) {
        return NO;
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:gifFilePath];
    
    //判断是否正常打开文件
    if (fileHandle == nil) {
        return NO;
    }
    
    //判断是否为GIF
    if ([self p_checkGIF:fileHandle]) {
        int index = 0;
        //头部3字节为GIF，3字节为"87a"或"89a"版本号，跳过
        index += 6;
        //接下来有7个字节的逻辑屏幕标识符，跳过其中逻辑屏幕宽度，逻辑屏幕高度
        index += 4;
        
        [fileHandle seekToFileOffset:index];
        
        //读取是否含有全局颜色列表
        uint8_t hasGlobalColorTable = 0x00;
        if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&hasGlobalColorTable] == NO) {
            return NO;
        }
        
        //先跳过7个字节的逻辑屏幕标识符中背景色和像素宽高比
        [fileHandle seekToFileOffset:fileHandle.offsetInFile + 2];
        
        if (hasGlobalColorTable >= 0x80) {
            //存在全局颜色列表，跳过全局颜色列表
            NSUInteger pixel = (NSUInteger)(((uint8_t)(hasGlobalColorTable << 5)) >> 5);
            //全局颜色列表大小为 3 * 2的(pixel + 1)次方
            [fileHandle seekToFileOffset:fileHandle.offsetInFile + (3 * pow(2, pixel + 1))];
        }
        
        while (YES) {
            //标识
            uint8_t identifier;
            if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&identifier] == NO) {  //读取完毕
                [fileHandle synchronizeFile];
                [fileHandle closeFile];
                return YES;
            }
            if (identifier == 0x21) {   //处理可能为标识块的数据
                [self p_handleIdentifierBlockWithFileHandle:fileHandle changeSpeedType:changeSpeedType value:value];
            } else if (identifier == 0x2c) {    //处理图像
                [self p_handleImageDataWithFileHandle:fileHandle];
            }
        }
        
    } else {
        [fileHandle closeFile];
        return NO;
    }
}

///检查是否为GIF
+ (BOOL)p_checkGIF:(NSFileHandle *)fileHandle {
    if (fileHandle == nil) {
        return NO;
    }
    [fileHandle seekToFileOffset:0];
    uint8_t g;
    uint8_t i;
    uint8_t f;
    if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&g] == YES && g == 0x47 &&
        [self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&i] == YES && i == 0x49 &&
        [self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&f] == YES && f == 0x46) {
        return YES;
    }
    return NO;
}

///获取对应data的数据
+ (BOOL)p_getUint8WithData:(NSData *)data result:(uint8_t *)result {
    if (data.length == 0 || result == NULL) {
        return NO;
    }
    CFDataRef dataRef = (__bridge CFDataRef)data;
    const char *bytes = (char *)CFDataGetBytePtr(dataRef);
    *result = *((uint8_t *)bytes);
    return YES;
}

///处理图像数据
+ (void)p_handleImageDataWithFileHandle:(NSFileHandle *)fileHandle {
    //跳过2字节X方向偏移量，2字节Y方向偏移量，2字节图象宽度，2字节图象高度
    [fileHandle seekToFileOffset:fileHandle.offsetInFile + 8];
    
    //读取是否含有局部颜色列表
    uint8_t hasLocalColorTable = 0x00;
    if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&hasLocalColorTable] == NO) {
        return;
    }
    
    if (hasLocalColorTable >= 0x80) {
        //存在局部颜色列表，跳过局部颜色列表
        NSUInteger pixel = (NSUInteger)(((uint8_t)(hasLocalColorTable << 5)) >> 5);
        //局部颜色列表大小为 3 * 2的(pixel + 1)次方
        [fileHandle seekToFileOffset:fileHandle.offsetInFile + (3 * pow(2, pixel + 1))];
    }
    
    //跳过LZW编码长度
    [fileHandle seekToFileOffset:fileHandle.offsetInFile + 1];
    
    //处理图像数据块
    [self p_handleDataBlockWithFileHandle:fileHandle];
}

///处理可能为标识块的数据
+ (void)p_handleIdentifierBlockWithFileHandle:(NSFileHandle *)fileHandle changeSpeedType:(GIFChangeSpeedType)changeSpeedType value:(CGFloat)value {
    uint8_t subIdentifier = 0x00;
    if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&subIdentifier]) {
        if (subIdentifier == 0xf9) {    //可能为图形控制拓展
            [self p_handleGraphicControlExtensionWithFileHandle:fileHandle changeSpeedType:changeSpeedType value:value];
        } else if (subIdentifier == 0xfe) { //确定为注释拓展
            [self p_handleCommentExtensionWithFileHandle:fileHandle];
        } else if (subIdentifier == 0x01) { //可能为图形文本拓展
            [self p_handlePlainTextExtensionWithFileHandle:fileHandle];
        } else if (subIdentifier == 0xff) { //可能为应用程序扩展
            [self p_handleApplicationExtensionWithFileHandle:fileHandle];
        }
    }
}

///处理可能为图形控制拓展
+ (void)p_handleGraphicControlExtensionWithFileHandle:(NSFileHandle *)fileHandle changeSpeedType:(GIFChangeSpeedType)changeSpeedType value:(CGFloat)value {
    uint8_t subSubIdentifier = 0x00;
    if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&subSubIdentifier]) {
        if (subSubIdentifier == 0x04) { //确认为图形控制拓展
            //跳过一个字节的信息
            [fileHandle seekToFileOffset:fileHandle.offsetInFile + 1];
            
            //查看是否有标识块终结
            [fileHandle seekToFileOffset:fileHandle.offsetInFile + 3];
            
            //Block Terminator - 标识块终结，固定值0
            uint8_t blockTerminator;
            if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&blockTerminator] == YES && blockTerminator ==  0x00) {
                [fileHandle seekToFileOffset:fileHandle.offsetInFile - 4];
                
                uint8_t low = 0x00;
                uint8_t high = 0x00;
                if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&low] &&
                    [self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&high]) {
                    //                    NSLog(@"%02x %02x", low, high);
                    [self p_changeSpeedWithLow:low high:high fileHandle:fileHandle changeSpeedType:changeSpeedType value:value];
                }
            }
        }
    }
}

///处理注释拓展
+ (void)p_handleCommentExtensionWithFileHandle:(NSFileHandle *)fileHandle {
    //在判断注释拓展时已经处理了拓展块标识和注释块标签，直接处理注释块和块终结器就好
    [self p_handleDataBlockWithFileHandle:fileHandle];
}

///处理可能为图形文本拓展
+ (void)p_handlePlainTextExtensionWithFileHandle:(NSFileHandle *)fileHandle {
    uint8_t subSubIdentifier = 0x00;
    if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&subSubIdentifier]) {
        if (subSubIdentifier == 0x0c) { //确认为图形文本拓展
            //跳过2字节文本框左边界位置，2字节文本框上边界位置，2字节文本框高度，2字节文本框高度，1字节字符单元格宽度，1字节字符单元格高度，1字节文本前景色索引，1字节文本背景色索引
            [fileHandle seekToFileOffset:fileHandle.offsetInFile + 12];
            
            //跳过文本数据块
            [self p_handleDataBlockWithFileHandle:fileHandle];
        }
    }
}

///处理可能为应用程序扩展
+ (void)p_handleApplicationExtensionWithFileHandle:(NSFileHandle *)fileHandle {
    uint8_t subSubIdentifier = 0x00;
    if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&subSubIdentifier]) {
        if (subSubIdentifier == 0x0b) { //确定为应用程序扩展
            //跳过8字节的应用程序标识符，3字节的应用程序鉴别码
            [fileHandle seekToFileOffset:fileHandle.offsetInFile + 11];
            
            //跳过应用程序数据数据块
            [self p_handleDataBlockWithFileHandle:fileHandle];
        }
    }
}

///跳过数据块
+ (void)p_handleDataBlockWithFileHandle:(NSFileHandle *)fileHandle {
    //读取块大小
    uint8_t blockSize = 0x00;
    if ([self p_getUint8WithData:[fileHandle readDataOfLength:1] result:&blockSize]) {
        if (blockSize == 0x00) {    //读取完毕(如果某个数据子块的第一个字节数值为0，即该数据子块中没有包含任何有用数据，则该子块称为块终结符，用来标识数据子块到此结束)
            return;
        } else {
            [fileHandle seekToFileOffset:fileHandle.offsetInFile + (NSUInteger)blockSize];
            //继续处理
            [self p_handleDataBlockWithFileHandle:fileHandle];
        }
    }
}

///调速
+ (void)p_changeSpeedWithLow:(uint8_t)low high:(uint8_t)high fileHandle:(NSFileHandle *)fileHandle changeSpeedType:(GIFChangeSpeedType)changeSpeedType value:(CGFloat)value {
    NSUInteger speed = 0;
    if (changeSpeedType == GIFChangeSpeedTypeMultiple) {
        speed = (NSUInteger)((uint16_t)(high << 8 | low));
        speed *= value;
    } else {
        //文件中存储的时间单位为 1/ 100 s
        speed = value * 100;
    }
    
    uint16_t newSpeed = (uint16_t)speed;
    uint8_t newLow = newSpeed & 0x00FF;
    uint8_t newHigh = (newSpeed & 0xFF00) >> 8;
    
    NSData *data = nil;
    [fileHandle seekToFileOffset:fileHandle.offsetInFile - 2];
    
    data = [NSData dataWithBytes:(const void *)&newLow length:1];
    [fileHandle writeData:data];
    
    data = [NSData dataWithBytes:(const void *)&newHigh length:1];
    [fileHandle writeData:data];
}

@end
