//
//  Consumer.m
//  LockDemo
//
//  Created by cqh on 2019/5/21.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import "Consumer.h"

@implementation Consumer
- (instancetype)initWithConditon:(NSCondition  *)condition collector:(NSMutableArray *)collector{
    
    self = [super init];
    if (self) {
        self.condition = condition;
        self.collector = collector;
        self.shouldConsumer = NO;
        self.itemName = nil;
    }
    return self;
}

-(void)consumer{
    self.shouldConsumer = YES;
    while (self.shouldConsumer) {
        [self.condition lock];
        if (self.collector.count == 0 ) {
            [self.condition wait];
        }
        
        NSString *item = [self.collector objectAtIndex:0];
        NSLog(@"买入:%@",item);
        [self.collector removeObjectAtIndex:0];
        [self.condition signal];
        [self.condition unlock];
    }
}
@end
