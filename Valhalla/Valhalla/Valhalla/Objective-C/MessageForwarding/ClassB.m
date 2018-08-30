//
//  ClassB.m
//  MessageForwarding
//
//  Created by 马德茂 on 2018/4/23.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "ClassB.h"
#import <objc/runtime.h>

@implementation ClassB

void imp_testMethod2(id obj, SEL sel, NSString *string) {
    NSLog(@"ClassB->imp_testMethod2->%@", string);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if ([[NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding] isEqualToString:@"testMethod2:"]) {
        class_addMethod(self, sel, (IMP)imp_testMethod2, "v@:@");
        return YES;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

- (void)testMethod3:(NSString *)string {
    NSLog(@"ClassB->testMethod3->%@", string);
}

@end
