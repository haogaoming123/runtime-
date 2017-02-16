//
//  MyClass.h
//  runtime01
//
//  Created by haogaoming on 2017/2/15.
//  Copyright © 2017年 郝高明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject<NSCopying,NSCoding>

@property (nonatomic,strong) NSArray  *array;
@property (nonatomic,  copy) NSString *string;

-(void) method1;
-(void) method2;
+(void) classMethod1;
@end
