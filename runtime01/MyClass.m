//
//  MyClass.m
//  runtime01
//
//  Created by haogaoming on 2017/2/15.
//  Copyright © 2017年 郝高明. All rights reserved.
//

#import "MyClass.h"
#import <objc/runtime.h>
#import "funNoSelector.h"

@interface MyClass ()
{
    NSInteger _instance1;
    NSString  *_instance2;
    funNoSelector *_helper;
}

@property (nonatomic,assign) NSUInteger integer;

-(void) method3WithArg1:(NSUInteger)arg1 arg2:(NSString *)arg2;

@end

@implementation MyClass

-(instancetype)init
{
    if (self = [super init]) {
        _helper = [[funNoSelector alloc]init];
    }
    return self;
}

+(void)classMethod1
{
    
}

-(void)method1
{
    NSLog(@"call method method1");
}

-(void)method2
{
    
}

-(void)method3WithArg1:(NSUInteger)arg1 arg2:(NSString *)arg2
{
    NSLog(@"arg1 : %ld , arg2 : %@",arg1,arg2);
}


+(BOOL)resolveClassMethod:(SEL)sel
{
    //    NSString *selectorString = NSStringFromSelector(sel);
    class_addMethod([self class], sel, (IMP)funnoSelecor, "v@:");
    
    return [super resolveClassMethod:sel];
}

void funnoSelecor(id self,SEL _cmd) {
    NSLog(@"呵呵：%@,%p",self,_cmd);
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    NSLog(@"forwardingTargetForSelector");
    if ([NSStringFromSelector(aSelector) isEqualToString:@"methodTest"]) {
        return _helper;
    }
//    BOOL result = class_addMethod([self class], aSelector, (IMP)funnoSelecor, "v@:");
//    NSLog(@"是否添加成功：%@",result?@"成功":@"失败");
    return [super forwardingTargetForSelector:aSelector];
}
@end
