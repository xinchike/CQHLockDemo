//
//  RecursiveViewController.m
//  LockDemo
//
//  Created by cqh on 2019/5/21.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import "RecursiveViewController.h"

@interface RecursiveViewController ()
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@end

@implementation RecursiveViewController

#pragma mark  ---- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"递归锁";
    self.view.backgroundColor = [UIColor blueColor];
    
    [self setupUI];
}

#pragma mark  ---- setup UI
-(void)setupUI {
    [self.view addSubview:self.btn1];
    [self.view addSubview:self.btn2];
    //    [self.view addSubview:self.btn3];
    //    [self.view addSubview:self.btn4];
    
    [self setupConstraints];
}

- (void)setupConstraints {
}

#pragma mark  ---- bussiness methods
-(void)normalLock {
    //    __block atomic_int count = 0;
    
    NSLock *lock = [[NSLock alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        static void (^RecursiveMethod)(int);
        
        RecursiveMethod = ^(int value) {
            
            [lock lock];
            if (value > 0) {
                
                NSLog(@"value = %d", value);
                sleep(2);
                RecursiveMethod(value - 1);
            }
            [lock unlock];
        };
        
        RecursiveMethod(5);
    });
}

-(void)RecursiveLock {
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        static void (^RecursiveMethod)(int);
        
        RecursiveMethod = ^(int value) {
            
            [lock lock];
            if (value > 0) {
                
                NSLog(@"value = %d", value);
                sleep(1);
                RecursiveMethod(value - 1);
            }
            [lock unlock];
        };
        
        RecursiveMethod(1000);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        sleep(1);
        BOOL flag = [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        if (flag) {
            NSLog(@"lock before date");
            
            [lock unlock];
        } else {
            NSLog(@"fail to lock before date");
        }
    });
}




#pragma mark  ---- actions
-(void) buttonPressed:(id)sender {
    if (sender == self.btn1) {
        [self normalLock];
    } else if (sender == self.btn2) {
        [self RecursiveLock];
    }
}

#pragma mark  ---- getters
- (UIButton *)btn1 {
    if (!_btn1) {
        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 200, 30)];
        [_btn1 setTitle:@"普通锁" forState:UIControlStateNormal];
        [_btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

- (UIButton *)btn2 {
    if (!_btn2) {
        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 250, 200, 30)];
        [_btn2 setTitle:@"递归锁" forState:UIControlStateNormal];
        [_btn2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}

- (UIButton *)btn3 {
    if (!_btn3) {
        _btn3 = [[UIButton alloc] initWithFrame:CGRectMake(10, 300, 200, 30)];
        [_btn3 setTitle:@"乱序" forState:UIControlStateNormal];
        [_btn3 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn3;
}

- (UIButton *)btn4 {
    if (!_btn4) {
        _btn4 = [[UIButton alloc] initWithFrame:CGRectMake(10, 350, 200, 30)];
        [_btn4 setTitle:@"内存泄漏" forState:UIControlStateNormal];
        [_btn4 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn4;
}

@end
