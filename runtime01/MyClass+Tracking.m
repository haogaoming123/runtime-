//
//  MyClass+Tracking.m
//  runtime01
//
//  Created by haogaoming on 2017/2/17.
//  Copyright © 2017年 郝高明. All rights reserved.
//

#import "MyClass+Tracking.h"
#import <objc/runtime.h>

@implementation MyClass (Tracking)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        //系统的方法
        SEL originalSelector = @selector(description);
        //要替换的方法
        SEL swizzledSelector = @selector(xx_description);
        
        //获取实例方法
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzleMethod = class_getInstanceMethod(class, swizzledSelector);
        
        //添加新方法
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        
        if (didAddMethod) {
            //替换
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else {
            //交换
            method_exchangeImplementations(originalMethod, swizzleMethod);
        }
    });
}

-(void)xx_description
{
    [self xx_description];
    NSLog(@"我被调用了");
}

@end
