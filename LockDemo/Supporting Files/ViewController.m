//
//  ViewController.m
//  LockDemo
//
//  Created by cqh on 2019/5/20.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import "ViewController.h"
#import "CQHMainPageTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CQHMainPageTableViewController *vc = [[CQHMainPageTableViewController alloc] init];
    [self pushViewController:vc animated:NO];
}


@end
