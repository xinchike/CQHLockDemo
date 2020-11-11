//
//  Consumer.h
//  LockDemo
//
//  Created by cqh on 2019/5/21.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Consumer : NSObject
@property (nonatomic, assign) BOOL shouldConsumer;

@property (nonatomic, strong) NSString *itemName;

@property (nonatomic, strong) NSCondition *condition;

@property (nonatomic, strong) NSMutableArray *collector;
- (instancetype)initWithConditon:(NSCondition *)condition collector:(NSMutableArray *)collector;
- (void)consumer;
@end

NS_ASSUME_NONNULL_END
