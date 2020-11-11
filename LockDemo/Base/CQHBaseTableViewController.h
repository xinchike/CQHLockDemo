//
//  CQHBaseTableViewController.h
//  LockDemo
//
//  Created by cqh on 2019/5/20.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQHBaseTableViewController : UITableViewController

-(void)configCells;
- (void)addCell:(NSString *)title className:(NSString *)className;
@end

NS_ASSUME_NONNULL_END
