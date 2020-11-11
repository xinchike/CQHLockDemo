//
//  CQHBaseTableViewController.m
//  LockDemo
//
//  Created by cqh on 2019/5/20.
//  Copyright © 2019年 cqh. All rights reserved.
//

#import "CQHBaseTableViewController.h"

@interface CQHBaseTableViewController ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@end

@implementation CQHBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Lock Demo";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self configCells];
}

-(void)configCells {
    NSAssert(false, @"Please implementaton this method to config cells");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - methods
- (void)addCell:(NSString *)title className:(NSString *)className {
    if (title && className) {
        
        [self.titles addObject:title];
        [self.classNames addObject:className];
    }
}

#pragma getters and setters
- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray *)classNames {
    if (!_classNames) {
        _classNames = [NSMutableArray array];
    }
    return _classNames;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIndentifier = @"myOpenGLDemo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIndentifier];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class && [class isSubclassOfClass:[UIViewController class]]) {
        UIViewController *vc = class.new;
        vc.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
