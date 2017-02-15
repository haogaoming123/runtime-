//
//  main.m
//  runtime01
//
//  Created by haogaoming on 2017/2/15.
//  Copyright © 2017年 郝高明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyClass.h"
#import <objc/runtime.h>

void TestMetaClass(id self, SEL _cmd) {
    NSLog(@"this object is %p",self);
    NSLog(@"Class id %@,super class is %@",[self class],[self superclass]);
    
    Class currentClass = [self class];
    for (int i=0; i<4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p",i,currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    
    
    NSLog(@"NSObject is class is %p",[NSObject class]);
    NSLog(@"NSObject is meta class is %p",objc_getClass((__bridge void *)[NSObject class]));
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
        class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
        objc_registerClassPair(newClass);
    
        id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
        [instance performSelector:@selector(testMetaClass)];
    
        NSLog(@"=================== runtime对象实践 ============================");
        // runtime对象实践
        MyClass *myclass = [[MyClass alloc]init];
        unsigned int outCount = 0;
    
        Class cls = myclass.class;
    
        //类名
        NSLog(@"class name is %s",class_getName(cls));
    
        NSLog(@"=============================================");
    
        //父类名字
        NSLog(@"super calss name: %s",class_getName(class_getSuperclass(cls)));
    
        NSLog(@"==============================================");
        
        //是否是元类
        NSLog(@"MyClass is %@ a meta-class",class_isMetaClass(cls) ? @"" : @"not");
        
        NSLog(@"==============================================");
        
        //获取元类
        Class meta_class = objc_getMetaClass(class_getName(cls));
        NSLog(@"%s's meta-class is %s",class_getName(cls),class_getName(meta_class));
        
        NSLog(@"==============================================");
        
        //变量实例大小
        NSLog(@"instance size : %zu",class_getInstanceSize(cls));
        
        NSLog(@"==============================================");
        
        //打印成员变量
        Ivar *ivars = class_copyIvarList(cls, &outCount);
        for (int i=0; i<outCount; i++) {
            Ivar ivar = ivars[i];
            NSLog(@"instance variable's name : %s at index: %d",ivar_getName(ivar),i);
        }
        free(ivars);
        
        NSLog(@"==============================================");

    }
    return 0;
}


