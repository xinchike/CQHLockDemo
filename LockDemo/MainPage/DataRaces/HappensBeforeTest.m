//
//  HappensBeforeTest.m
//  LockDemo
//
//  Created by cqh on 2019/5/21.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import "HappensBeforeTest.h"



@implementation HappensBeforeTest

int a=0;
int b=1;
void func(){
    a=b+22;
    b=22;
}
@end
