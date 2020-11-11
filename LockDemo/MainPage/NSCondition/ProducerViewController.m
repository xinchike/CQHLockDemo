//
//  ProducerViewController.m
//  LockDemo
//
//  Created by cqh on 2019/5/21.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import "ProducerViewController.h"
#import "Producer.h"
#import "Consumer.h"

@interface ProducerViewController ()

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;

@property (nonatomic, strong) Producer *producer;
@property (nonatomic, strong) Consumer *cunsumer;

@end


NSMutableArray *pipeline = nil;
NSCondition *conditon = nil;

@implementation ProducerViewController

#pragma mark  ---- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"生产者消费者";
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
-(void)start {
    //    __block atomic_int count = 0;
    pipeline = [NSMutableArray array];
    conditon = [NSCondition new];
    
    self.producer = [[Producer alloc]initWithConditon:conditon collector:pipeline];
    self.cunsumer = [[Consumer alloc]initWithConditon:conditon collector:pipeline];
    [[[NSThread alloc] initWithTarget:self.producer selector:@selector(produce) object:self.producer] start];
    [[[NSThread alloc] initWithTarget:self.cunsumer selector:@selector(consumer) object:self.cunsumer] start];
}

-(void)stop {
    self.producer.shouldProduce = NO;
    self.cunsumer.shouldConsumer = NO;
}


#pragma mark  ---- actions
-(void) buttonPressed:(id)sender {
    if (sender == self.btn1) {
        [self start];
    } else if (sender == self.btn2) {
        [self stop];
    }
}

#pragma mark  ---- getters
- (UIButton *)btn1 {
    if (!_btn1) {
        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 200, 30)];
        [_btn1 setTitle:@"开始购买" forState:UIControlStateNormal];
        [_btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

- (UIButton *)btn2 {
    if (!_btn2) {
        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 250, 200, 30)];
        [_btn2 setTitle:@"停止" forState:UIControlStateNormal];
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
