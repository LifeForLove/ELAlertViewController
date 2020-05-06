//
//  ViewController.m
//  ELAlertViewControllerDemo
//
//  Created by 高欣 on 2020/5/6.
//  Copyright © 2020 getElementByYou. All rights reserved.
//

#import "ViewController.h"
#import "ELAlertViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"style1";
            break;
        case 1:
            cell.textLabel.text = @"style2";
            break;
        case 2:
            cell.textLabel.text = @"style3";
            break;
        case 3:
            cell.textLabel.text = @"style4";
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            ELAlertViewController * alert = [ELAlertViewController el_alertControllerAlertStyleWithTitle:@"标题" message:nil];
            
            ELAlertAction * action1 = [ELAlertAction el_actionWithTitle:@"title1" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action1");
            }];
            
            ELAlertAction * action2 = [ELAlertAction el_actionWithTitle:@"title2" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action2");
            }];
            
            
            ELAlertAction * action3 = [ELAlertAction el_actionWithTitle:@"title3" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action3");
            }];
            
            [alert el_addAction:action1];
            [alert el_addAction:action2];
            [alert el_addAction:action3];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 1:
        {
            ELAlertViewController * alert = [ELAlertViewController el_alertControllerAlertStyleWithTitle:@"标题" message:@"内容"];
            
            ELAlertAction * action1 = [ELAlertAction el_actionWithTitle:@"title1" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action1");
            }];
            action1.textColor = [UIColor blueColor];
            action1.textFont = [UIFont boldSystemFontOfSize:15];
            
            ELAlertAction * action2 = [ELAlertAction el_actionWithTitle:@"title2" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action2");
            }];
            action2.textColor = [UIColor redColor];
            
            [alert el_addAction:action1];
            [alert el_addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 2:
        {
            ELAlertViewController * alert = [ELAlertViewController el_alertControllerAlertStyleWithTitle:@"标题" message:@"内容"];
            
            ELAlertAction * action1 = [ELAlertAction el_actionWithTitle:@"title1" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action1");
            }];
            
            [alert el_addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 3:
        {
            ELAlertViewController * alert = [ELAlertViewController el_alertControllerWithActionSheetStyle];
            
            ELAlertAction * action1 = [ELAlertAction el_actionWithTitle:@"title1" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action1");
            }];
            
            ELAlertAction * action2 = [ELAlertAction el_actionWithTitle:@"title2" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action2");
            }];
            
            
            ELAlertAction * action3 = [ELAlertAction el_actionWithTitle:@"title3" handler:^(ELAlertAction * _Nonnull action) {
                NSLog(@"action3");
            }];
            
            [alert el_addAction:action1];
            [alert el_addAction:action2];
            [alert el_addAction:action3];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}






@end
