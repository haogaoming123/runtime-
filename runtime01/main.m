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

void imp_submethod1(id self,SEL _cmd,NSNumber* index) {
    NSLog(@"run sub method %ld",(long)index.integerValue);
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

        //获取指定的成员变量
        Ivar string = class_getInstanceVariable(cls, "_string");
        if (string != NULL) {
            NSLog(@"instace variable %s",ivar_getName(string));
        }
        
        NSLog(@"==============================================");
        
        //属性操作
        objc_property_t *properties = class_copyPropertyList(cls, &outCount);
        for (int i=0; i<outCount; i++) {
            objc_property_t property = properties[i];
            NSLog(@"property's name : %s",property_getName(property));
        }
        free(properties);
        
        NSLog(@"==============================================");
        
        //获取指定的属性
        objc_property_t array = class_getProperty(cls, "array");
        if (array != NULL) {
            NSLog(@"property %s",property_getName(array));
        }
        
        NSLog(@"==============================================");
        
        //方法操作
        Method *methods = class_copyMethodList(cls, &outCount);
        for (int i=0; i<outCount; i++) {
            Method method = methods[i];
            NSLog(@"method's signature : %s",method_getName(method));
        }
        free(methods);
        
        NSLog(@"==============================================");
        
        //获取实例方法
        Method method1 = class_getInstanceMethod(cls, @selector(method1));
        if (method1 != NULL) {
            NSLog(@"method is : %s",method_getName(method1));
        }
        
        NSLog(@"==============================================");
        
        //获取类方法
        Method method2 = class_getClassMethod(cls, @selector(classMethod1));
        if (method2) {
            NSLog(@"class method is : %s",method_getName(method2));
        }
        
        NSLog(@"==============================================");
        
        //打印方法的具体实现--查看方法的实现
        IMP imp = class_getMethodImplementation(cls, @selector(method1));
        imp();
        
        NSLog(@"==============================================");
        
        //协议
        Protocol * __unsafe_unretained *protocols = class_copyProtocolList(cls, &outCount);
        Protocol *protocol;
        for (int i=0; i<outCount; i++) {
            protocol = protocols[i];
            NSLog(@"protocol name is : %s",protocol_getName(protocol));
        }
        
        NSLog(@"==============================================");
        
        Class clss = objc_allocateClassPair(myclass.class, "MySubClass", 0);
        //添加方法
        class_addMethod(clss, @selector(method3), (IMP)imp_submethod1, "v@:");
        //替换方法
        class_replaceMethod(clss, @selector(method1), (IMP)imp_submethod1, "v@:");
        //添加属性
        //属性类型  name值：T  value：变化
        //编码类型  name值：C(copy) &(strong) W(weak) 空(assign) 等 value：无
        //非/原子性 name值：空(atomic) N(Nonatomic)  value：无
        //变量名称  name值：V  value：变化
//        objc_property_attribute_t type =
        objc_registerClassPair(clss);
        
        id mySubClass = [[clss alloc] init];
        [mySubClass performSelector:@selector(method3) withObject:@(123)];
        [mySubClass performSelector:@selector(method1) withObject:@(321)];
        
        objc_property_t *mysubClassIvar = class_copyPropertyList(clss, &outCount);
        for (int i=0; i<outCount; i++) {
            objc_property_t ivar = mysubClassIvar[i];
            NSLog(@"MySubClass's property is : %s",property_getName(ivar));
        }
        free(mysubClassIvar);
        
        NSLog(@"=========================================");
    }
    return 0;
}


