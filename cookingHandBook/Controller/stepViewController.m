//
//  stepViewController.m
//  HowToEat
//
//  Created by FangZ on 16/6/27.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import "stepViewController.h"
#import "HTEdetailView.h"

#define headerViewHeight    64

@interface stepViewController ()

@property (retain, nonatomic)HTEdetailView *detailVC;

@end

@implementation stepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadHeaderView];

    self.detailVC = [[HTEdetailView alloc] init];
    self.detailVC.detailModel = self.detailModel;
    [self.detailVC initDetailView];
    [self.view addSubview:self.detailVC];
}

- (void)loadHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headerViewHeight)];
    headerView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:1];
    
    //添加返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 24, 30, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    [self.view addSubview:headerView];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    self.detailModel = nil;
}

- (void)dealloc{
    NSLog(@"dddd");
}

- (void)viewWillDisappear:(BOOL)animated{
    self.detailVC.detailModel = nil;
    [self.detailVC removeFromSuperview];
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}



@end
