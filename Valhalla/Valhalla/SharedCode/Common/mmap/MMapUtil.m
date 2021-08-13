//
//  MMapUtil.m
//  Valhalla
//
//  Created by mademao on 2021/7/29.
//  Copyright © 2021 mademao. All rights reserved.
//

#import "MMapUtil.h"
#import <sys/mman.h>

#define MMapLength (100000)

@interface MMapUtil ()

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) BOOL readonly;
@property (nonatomic, assign) void *buffer;

@end

@implementation MMapUtil

- (instancetype)initWithFilePath:(NSString *)filePath
                        readonly:(BOOL)readonly {
    if (self = [super init]) {
        self.filePath = filePath;
        self.readonly = readonly;
        self.buffer = NULL;
        [self mmapFilePath];
    }
    return self;
}

- (void)write:(NSString *)value {
    if (self.readonly) {
        return;
    }
    if (self.buffer == NULL) {
        return;
    }
    const char *c = [value cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned long size = strlen(c);
    unsigned long pSize = sizeof(unsigned long);
    memset(self.buffer, 0, MMapLength);
    memcpy(self.buffer, &size, pSize);
    memcpy(self.buffer + pSize, c, size);
}

- (NSString *)read {
    if (self.buffer == NULL) {
        return @"";
    }
    unsigned long pSize = sizeof(unsigned long);
    unsigned long size = 0;
    memcpy(&size, self.buffer, pSize);
    return [NSString stringWithCString:self.buffer + pSize encoding:NSUTF8StringEncoding];
}

- (void)mmapFilePath {
    if (self.readonly) {
        int fd = open(self.filePath.UTF8String, O_CREAT|O_RDONLY, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);
        if (fd != -1) {
            off_t size = lseek(fd, 0, SEEK_END);
            self.buffer = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
            if (self.buffer == MAP_FAILED) {
                self.buffer = NULL;
            }
            close(fd);
        }
    } else {
        int fd = open(self.filePath.UTF8String, O_CREAT|O_RDWR, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);
        if (fd != -1) {
            int ret = ftruncate(fd, MMapLength);
            if (ret != -1) {
                self.buffer = mmap(NULL, MMapLength, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
                if (self.buffer == MAP_FAILED) {
                    self.buffer = NULL;
                }
            }
            close(fd);
        }
    }
}

@end
