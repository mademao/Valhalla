//
//  ClassA.m
//  MessageForwarding
//
//  Created by 马德茂 on 2018/4/23.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "ClassA.h"
#import <objc/runtime.h>
#import "ClassB.h"
#import "ClassC.h"

/**
 *  class_addMethod的type参数格式参考: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation ClassA

#pragma mark - 处理类方法

void imp_classTestMethod1(id obj, SEL sel, NSString *string) {
    NSLog(@"ClassA->imp_classTestMethod1->%@", string);
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    NSString *s = [NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding];
    if ([s isEqualToString:@"classTestMethod1:"]) {
        Class metaClass = objc_getMetaClass("ClassA");
        class_addMethod(metaClass, sel, (IMP)imp_classTestMethod1, "v@:@");
        return YES;
    } else {
        return [super resolveClassMethod:sel];
    }
}


#pragma mark - 处理实例方法

void imp_testMethod1(id obj, SEL sel, NSString *string) {
    NSLog(@"ClassA->imp_testMethod1->%@", string);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if ([[NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding] isEqualToString:@"testMethod1:"]) {
        class_addMethod(self, sel, (IMP)imp_testMethod1, "v@:@");
        return YES;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([[NSString stringWithCString:sel_getName(aSelector) encoding:NSUTF8StringEncoding] isEqualToString:@"testMethod2:"]) {
        ClassB *b = [[ClassB alloc] init];
        return b;
    } else {
        return [super forwardingTargetForSelector:aSelector];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([[NSString stringWithCString:sel_getName(aSelector) encoding:NSUTF8StringEncoding] isEqualToString:@"testMethod3:"]) {
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
        return methodSignature;
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([[NSString stringWithCString:sel_getName(anInvocation.selector) encoding:NSUTF8StringEncoding] isEqualToString:@"testMethod3:"]) {
        //ClassB和ClassC的testMethod3:一个未声明一个声明，但无所谓，只要在方法列表中能找到就可以
        
        //第一种方法
        //        [anInvocation invokeWithTarget:[[ClassB alloc] init]];
        //        [anInvocation invokeWithTarget:[[ClassC alloc] init]];
        
        //第二种方法，由于anInvocation.target的修饰符为weak，所以要提前创建好对象
        ClassB *b = [[ClassB alloc] init];
        anInvocation.target = b;
        [anInvocation invoke];
        
        ClassC *c = [[ClassC alloc] init];
        anInvocation.target = c;
        [anInvocation invoke];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end

#pragma clang diagnostic pop
