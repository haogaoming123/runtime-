//
//  funNoSelector.m
//  runtime01
//
//  Created by haogaoming on 2017/2/17.
//  Copyright © 2017年 郝高明. All rights reserved.
//

#import "funNoSelector.h"

@implementation funNoSelector

-(void)methodTest
{
    NSLog(@"处错误了：%@,%p",self,_cmd);
}
@end
