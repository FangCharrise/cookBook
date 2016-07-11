//
//  ViewController.m
//  HowToEat
//
//  Created by FangZ on 16/6/17.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import "ViewController.h"
#import "searchViewController.h"

@interface ViewController ()<UIBarPositioningDelegate,UISearchBarDelegate>

@property (strong, nonatomic)NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%f",self.view.bounds.size.height);
    self.navigationController.navigationBar.hidden = YES;
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 40)];
    searchBar.placeholder = @"搜索菜谱、食材";
    [[[searchBar.subviews objectAtIndex:0].subviews objectAtIndex:0] removeFromSuperview];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchViewController *searchNVC = [[searchViewController alloc]init];
    [self.navigationController pushViewController:searchNVC animated:YES];
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    NSLog(@"%f ==%f", touchPoint.x, touchPoint.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
