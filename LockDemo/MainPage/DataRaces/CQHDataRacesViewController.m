//
//  CQHDataRacesViewController.m
//  LockDemo
//
//  Created by cqh on 2019/5/20.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import "CQHDataRacesViewController.h"
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>
#import <stdatomic.h>

@interface CQHDataRacesViewController ()
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;

@property (atomic, assign) NSInteger aaa;

@property (nonatomic, strong) NSMutableString *mutaStr;
@end

@implementation CQHDataRacesViewController

#pragma mark  ---- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Data races 导致的出错";
    self.view.backgroundColor = [UIColor blueColor];
    
    [self setupUI];
}

#pragma mark  ---- setup UI
-(void)setupUI {
    [self.view addSubview:self.btn1];
    [self.view addSubview:self.btn2];
    [self.view addSubview:self.btn3];
    [self.view addSubview:self.btn4];
    
    [self setupConstraints];
}

- (void)setupConstraints {
}

#pragma mark  ---- bussiness methods
-(void)countErr {
//    __block atomic_int count = 0;
    __block int count = 0;
    self.aaa = 0;
    NSLock *lock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10000; i ++) {
//            count ++;
//            self.aaa ++;
//            self.aaa = 100;
            [lock lock];
            OSAtomicIncrement32(&count);
            [lock unlock];
//            atomic_fetch_add_explicit(&count, 0, memory_order_seq_cst);
//            atomic_fetch_add_explicit(&count, 1, memory_order_seq_cst);
            if (9999 == i) {
                NSLog(@"子线程1循环结束，count = %d", count);
//                NSLog(@"子线程3循环结束，count = %d self.aaa=%ld", count, self.aaa);
            }
        }
    });
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10000; i ++) {
            count ++;
//            self.aaa ++;
            
            [lock lock];
            OSAtomicIncrement32(&count);
            [lock unlock];
//            atomic_fetch_add_explicit(&count, 1, memory_order_seq_cst);
            if (9999 == i) {
                NSLog(@"子线程2循环结束，count = %d", count);
//                NSLog(@"子线程3循环结束，count = %d self.aaa=%ld", count, self.aaa);
            }
        }
    });
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10000; i ++) {
//            count ++;
//            self.aaa ++;
            
            [lock lock];
            OSAtomicIncrement32(&count);
            [lock unlock];
//            atomic_fetch_add_explicit(&count, 1, memory_order_seq_cst);
            if (9999 == i) {
                NSLog(@"子线程3循环结束，count = %d", count);
//                NSLog(@"子线程3循环结束，count = %d self.aaa=%ld", count, self.aaa);
            }
        }
    });
}

-(void)crashTest {
    __block NSMutableString* str = [@"" mutableCopy];
    self.mutaStr = [@"" mutableCopy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10000; i ++) {
//            [str setString:@"adfadsf"];
//            [self.mutaStr setString:@"adfadsf"];
//            self.mutaStr = [@"adfadsf" mutableCopy];
            str = [@"adfadsf" mutableCopy];
        }
    });
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10000; i ++) {
//            [str setString:@"adfadsdadsfsad"];
//            [self.mutaStr setString:@"adfadsdadsfsad"];
//            self.mutaStr = [@"adfadsdadsfsad" mutableCopy];
            str = [@"adfadsdadsfsad" mutableCopy];
        }
    });
}

-(void)beginRace {
    __block int count = 0;
    __block bool countFinished = false;
    //thread 1
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10000; i ++) {
            count = 10;
            countFinished = true;
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10000; i ++) {
            count = 20;
            countFinished = false;
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        while (countFinished == false) {
            usleep(0.1);
            NSLog(@"count: %d", count);
        }
    });
}

#pragma mark  ---- actions
-(void) buttonPressed:(id)sender {
    if (sender == self.btn1) {
        [self countErr];
    } else if (sender == self.btn2) {
        [self crashTest];
    } else if (sender == self.btn3) {
        [self beginRace];
    }
}

#pragma mark  ---- getters
- (UIButton *)btn1 {
    if (!_btn1) {
        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 200, 30)];
        [_btn1 setTitle:@"计算出错" forState:UIControlStateNormal];
        [_btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

- (UIButton *)btn2 {
    if (!_btn2) {
        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 250, 200, 30)];
        [_btn2 setTitle:@"Carsh" forState:UIControlStateNormal];
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
