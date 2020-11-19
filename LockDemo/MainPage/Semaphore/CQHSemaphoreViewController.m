//
//  CQHSemaphoreViewController.m
//  LockDemo
//
//  Created by cqh on 2020/11/19.
//  Copyright © 2020 cqh. All rights reserved.
//

#import "CQHSemaphoreViewController.h"
#import <pthread.h>

@interface CQHSemaphoreViewController ()
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@end

@implementation CQHSemaphoreViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.title = @"信号量";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.btn1];
    [self.view addSubview:self.btn2];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIButton *)btn1 {
    if (!_btn1) {
        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 200, 30)];
        [_btn1 setTitle:@"信号量测试" forState:UIControlStateNormal];
        [_btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

- (UIButton *)btn2 {
    if (!_btn2) {
        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 250, 200, 30)];
        [_btn2 setTitle:@"读写锁测试" forState:UIControlStateNormal];
        [_btn2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}


-(void) buttonPressed:(id)sender {
    if (sender == self.btn1) {
        [self semaphoreTaskTest];
    } else if(sender == self.btn2){
        [self readWriteTest];
    }
}

/** 信号量测试 */
//用信号量锁实现 A、B执行完再执行C
- (void)semaphoreTaskTest{
    
    //crate的value表示，最多几个资源可访问。
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务A
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(quene, ^{
        NSLog(@"任务A准备开始 - 1");
        sleep(3);
        NSLog(@"任务A执行结束 - 1");
        dispatch_semaphore_signal(semaphore);
    });
    //任务B
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(quene, ^{
        NSLog(@"任务B准备开始 - 2");
        sleep(2);
        NSLog(@"任B执行结束 - 2");
        dispatch_semaphore_signal(semaphore);
    });
    //任务c
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务C准备开始 - 3");
        sleep(4);
        NSLog(@"任C执行结束 - 3");
        dispatch_semaphore_signal(semaphore);
        dispatch_semaphore_signal(semaphore);
    });
}


pthread_rwlock_t rwLock;
//读写锁实现 先执行A、B, 再执行C
-(void)readWriteTest {
    pthread_rwlock_init(&rwLock, NULL);
    
    //任务A
    pthread_rwlock_rdlock(&rwLock);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务A准备开始 - 1");
        sleep(3);
        NSLog(@"任务A执行结束 - 1");
        pthread_rwlock_unlock(&rwLock);
    });
    //任务B
    pthread_rwlock_rdlock(&rwLock);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务B准备开始 - 2");
        sleep(2);
        NSLog(@"任B执行结束 - 2");
        pthread_rwlock_unlock(&rwLock);
    });
    //任务c
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        pthread_rwlock_wrlock(&rwLock);
        NSLog(@"任务C准备开始 - 3");
        sleep(4);
        NSLog(@"任C执行结束 - 3");
        pthread_rwlock_unlock(&rwLock);
    });
}

@end
