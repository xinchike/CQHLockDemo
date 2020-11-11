//
//  Producer.m
//  LockDemo
//
//  Created by cqh on 2019/5/21.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import "Producer.h"

@implementation Producer
- (instancetype)initWithConditon:(NSCondition *)condition collector:(NSMutableArray *)collector{
    
    self = [super init];
    if (self) {
        self.condition = condition;
        self.collector = collector;
        self.shouldProduce = NO;
        self.itemName = nil;
    }
    return self;
}

-(void)produce{
    self.shouldProduce = YES;
    while (self.shouldProduce) {
        [self.condition lock];
        if (self.collector.count > 0 ) {
            [self.condition wait];
        }
        [self.collector addObject:@"iPhone"];
        NSLog(@"生产:iPhone");
        [self.condition signal];
        [self.condition unlock];
    }
}

@end
