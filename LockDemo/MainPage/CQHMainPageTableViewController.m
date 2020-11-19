//
//  CQHMainPageTableViewController.m
//  LockDemo
//
//  Created by cqh on 2019/5/20.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import "CQHMainPageTableViewController.h"

@interface CQHMainPageTableViewController ()

@end

@implementation CQHMainPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Lock Demo";
}

-(void)configCells {
    [self addCell:@"DataRaces" className:@"CQHDataRacesViewController"];
    [self addCell:@"LockPerformance" className:@"CQHLockPerformanceViewController"];
    [self addCell:@"生产者消费者" className:@"ProducerViewController"];
    [self addCell:@"读写锁" className:@"ReadWriteViewController"];
    [self addCell:@"Recursive" className:@"RecursiveViewController"];
    [self addCell:@"AB执行完再执行C" className:@"CQHSemaphoreViewController"];
//    [self addCell:@"SPTEBuyViewController" className:@"SPTEBuyViewController"];
//    [self addCell:@"FeedBack" className:@"FeedBack"];
}
@end
