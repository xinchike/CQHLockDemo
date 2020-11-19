//
//  ReadWriteViewController.m
//  LockDemo
//
//  Created by cqh on 2019/5/21.
//  Copyright © 2019年 cqh. All rights reserved.
//

//接口说明
//1、pthread_rwlock_init，初始化锁

//2、pthread_rwlock_rdlock，阻断性的读锁定读写锁
//3、pthread_rwlock_tryrdlock，非阻断性的读锁定读写锁
//4、pthread_rwlock_wrlock，阻断性的写锁定读写锁
//5、pthread_rwlock_trywrlock，非阻断性的写锁定读写锁

//6、pthread_rwlock_unlock，解锁
//7、pthread_rwlock_destroy，销毁锁释放


//读写锁，顾名思义是用来解决读和写的矛盾。读操作可以共享，写操作是独占或者说是排他的。
//简单点说就是，读的时候可以很多线程去读，写的时候只有一个线程在写，而且写的时候不允许读操作。
//1、申明读写锁，pthread_rwlock_t rwLock;
//2、初始化读写锁，pthread_rwlock_init(&rwLock, NULL);
//改Demo的意思是，有四个线程去读NSMutableString *paper;有四个线程去写NSMutableString *paper;他们间隔的时间都是随机的
//3、pthread_rwlock_rdlock，这个是阻断性的读锁，阻塞该线程，直到这个线程可以执行读操作为止。
//4、pthread_rwlock_tryrdlock，这个和3不同的是，一旦该线程有读写阻断，那么该方法就失败。
//5、pthread_rwlock_wrlock，这个是阻断性的写锁，阻塞该线程，直到这个线程可以执行写操作为止。
//6、pthread_rwlock_trywrlock，这个和5不同的是，一旦该线程有读写阻断，那么该方法就失败。
//7、读锁是共享锁，可以多个一起
//8、写锁是独占锁排它锁，同时只允许一个线程



#import "ReadWriteViewController.h"
#import <pthread.h>

@interface ReadWriteViewController ()

@property (nonatomic,strong) NSMutableString *paper;
@property (nonatomic,assign) int soldCount;
@end

@implementation ReadWriteViewController
static pthread_rwlock_t rwLock;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.paper = [NSMutableString stringWithCapacity:1];
    pthread_rwlock_init(&rwLock, NULL);
    
    [self forTest];
}

- (void)forTest
{
    
    NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(writePaper1) object:nil];
    [thread1 start];
    
    NSThread *thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(writePaper2) object:nil];
    [thread2 start];
    
    NSThread *thread3 = [[NSThread alloc]initWithTarget:self selector:@selector(writePaper3) object:nil];
    [thread3 start];
    
    NSThread *thread4 = [[NSThread alloc]initWithTarget:self selector:@selector(writePaper4) object:nil];
    [thread4 start];
    
//    NSThread *thread5 = [[NSThread alloc]initWithTarget:self selector:@selector(readPaper1) object:nil];
//    [thread5 start];
//
//    NSThread *thread6 = [[NSThread alloc]initWithTarget:self selector:@selector(readPaper2) object:nil];
//    [thread6 start];
//
//    NSThread *thread7 = [[NSThread alloc]initWithTarget:self selector:@selector(readPaper3) object:nil];
//    [thread7 start];
//
//    NSThread *thread8 = [[NSThread alloc]initWithTarget:self selector:@selector(readPaper4) object:nil];
//    [thread8 start];
    
}
-(void)readPaper1
{
    NSLog(@"====A进入读取文章,%@",self.paper);
    pthread_rwlock_rdlock(&rwLock);
//    pthread_rwlock_tryrdlock(&rwLock);

    NSLog(@"====A开始读取文章,%@",self.paper);
    sleep(arc4random()%2);
    NSLog(@"====A结束读取文章,%@",self.paper);
    pthread_rwlock_unlock(&rwLock);
    [self readPaper1];
}

-(void)readPaper2
{
    NSLog(@"====B进入读取文章,%@",self.paper);
    //    pthread_rwlock_rdlock(&rwLock);
    pthread_rwlock_tryrdlock(&rwLock);
    NSLog(@"====B开始读取文章,%@",self.paper);
    sleep(arc4random()%2);
    NSLog(@"====B结束读取文章,%@",self.paper);
    pthread_rwlock_unlock(&rwLock);
    [self readPaper2];
}
-(void)readPaper3
{
    NSLog(@"====C进入读取文章,%@",self.paper);
    //    pthread_rwlock_rdlock(&rwLock);
    pthread_rwlock_tryrdlock(&rwLock);
    NSLog(@"====C开始读取文章,%@",self.paper);
    sleep(arc4random()%2);
    NSLog(@"====C结束读取文章,%@",self.paper);
    pthread_rwlock_unlock(&rwLock);
    [self readPaper3];
}
-(void)readPaper4
{
    NSLog(@"====D进入读取文章,%@",self.paper);
//    pthread_rwlock_rdlock(&rwLock);
    pthread_rwlock_tryrdlock(&rwLock);
    NSLog(@"====D开始读取文章,%@",self.paper);
    sleep(arc4random()%2);
    NSLog(@"====D结束读取文章,%@",self.paper);
    pthread_rwlock_unlock(&rwLock);
    [self readPaper4];
}
- (void)writePaper1
{
    pthread_rwlock_wrlock(&rwLock);
//    pthread_rwlock_trywrlock(&rwLock);
    NSLog(@"====A进入定稿,%@",self.paper);
    sleep(arc4random()%5);
    [self.paper appendString:@"1"];
    [self.paper appendString:@"1"];
    [self.paper appendString:@"1"];
    NSLog(@"1结束写入");
    pthread_rwlock_unlock(&rwLock);
    [self writePaper1];
}
- (void)writePaper2
{
    NSLog(@"====B进入定稿,%@",self.paper);
    pthread_rwlock_wrlock(&rwLock);
//    pthread_rwlock_trywrlock(&rwLock);
    NSLog(@"2开始写入");
    sleep(arc4random()%5);
    [self.paper appendString:@"2"];
    [self.paper appendString:@"2"];
    [self.paper appendString:@"2"];
    NSLog(@"2结束写入");
    pthread_rwlock_unlock(&rwLock);
    
    [self writePaper2];
}
- (void)writePaper3
{
    NSLog(@"====C进入定稿,%@",self.paper);
        pthread_rwlock_wrlock(&rwLock);
//    pthread_rwlock_trywrlock(&rwLock);
    NSLog(@"3开始写入");
    sleep(arc4random()%5);
    [self.paper appendString:@"3"];
    [self.paper appendString:@"3"];
    [self.paper appendString:@"3"];
    NSLog(@"3结束写入");
    pthread_rwlock_unlock(&rwLock);
    
    [self writePaper3];
}
- (void)writePaper4
{
    NSLog(@"====D进入定稿,%@",self.paper);
    pthread_rwlock_wrlock(&rwLock);
//    pthread_rwlock_trywrlock(&rwLock);
    NSLog(@"4开始写入");
    sleep(arc4random()%5);
    [self.paper appendString:@"4"];
    [self.paper appendString:@"4"];
    [self.paper appendString:@"4"];
    NSLog(@"4结束写入");
    pthread_rwlock_unlock(&rwLock);
    
    [self writePaper4];
}

@end
