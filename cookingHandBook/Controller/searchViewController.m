//
//  searchViewController.m
//  HowToEat
//
//  Created by FangZ on 16/6/23.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import "searchViewController.h"
#import "HTEAPI.h"
#import "HTERequest.h"
#import "SVGloble.h"
#import "SVRootScrollView.h"
#import "SVTopScrollView.h"
#import "customTableViewCell.h"
#import "stepViewController.h"
#import "drawLabelView.h"
#import "MBProgressHUD+MJ.h"
#import "juheDataModel.h"


#define headerViewHeight    64

@interface searchViewController ()<HTERequestDelegate,UIBarPositioningDelegate,UITableViewDelegate,UITableViewDataSource,tapedLabelDelegate,UISearchBarDelegate>

@property (strong, nonatomic)UISearchBar *searchBar;
@property (strong, nonatomic)NSArray *dataArray;
@property (strong, nonatomic)UITextField *alertText;
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *array;
@property (strong, nonatomic)NSDictionary *resultDict;
@property (strong, nonatomic)UIActivityIndicatorView *activityView;
@property (strong, nonatomic)drawLabelView *historyView;
@property (strong, nonatomic)drawLabelView *hostSearchListView;

@end

//@class juheDataModel;

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:211 green:211 blue:211 alpha:0.9];
    self.searchBar.delegate = self;
    [self loadHeaderView];
    [self initActivityView];
    [self loadHorizontalScrollView];
    [self loadSearchHistoryView];
    [self loadHostSearchView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.searchBar becomeFirstResponder];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)loadSearchHistoryView{
    //获取沙盒目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename = [plistPath stringByAppendingPathComponent:@"history.plist"];
    //取数据
    NSArray *getHistoryArray = [NSArray arrayWithContentsOfFile:filename];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if ((getHistoryArray != nil)&&(getHistoryArray.count >1)) {
        for (int i = 0; i < getHistoryArray.count; i++) {
            [array addObject:getHistoryArray[getHistoryArray.count - (i + 1)]];
        }
        getHistoryArray = [NSArray arrayWithArray:array];
    }
    _historyView = [[drawLabelView alloc]initWithFrame:CGRectMake(0, 300, 0, 0) withHistory:getHistoryArray title:@"搜索历史"];
    _historyView.labelTpedDelegate = self;
    [self.view addSubview:_historyView];
}

- (void)loadHostSearchView{
    NSArray *getHistoryArray = [NSArray arrayWithObjects:@"虾",@"饼干",@"豆角",@"鸡肉",@"糖醋排骨",@"面包",@"中餐",@"饼",@"醋溜白菜", nil];
    _hostSearchListView = [[drawLabelView alloc]initWithFrame:CGRectMake(0, 100, 0, 0) withHistory:getHistoryArray title: @"美食热搜榜"];
    _hostSearchListView.labelTpedDelegate = self;
    [self.view addSubview:_hostSearchListView];
}

- (void)initActivityView{
    _activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _activityView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityView];
}

- (void)loadHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headerViewHeight)];
    headerView.backgroundColor = [UIColor orangeColor];
    
    //添加searchBar
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 24, 250, 30)];
    self.searchBar.placeholder = @"搜菜谱、食材";
    [[[self.searchBar.subviews objectAtIndex:0].subviews objectAtIndex:0] removeFromSuperview];
    [headerView addSubview:self.searchBar];
    
    //添加返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 24, 30, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    //添加开始搜索按钮
    UIButton *begainSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [begainSearch setFrame:CGRectMake(260, 24, 60, 30)];
    [begainSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [begainSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [begainSearch addTarget:self action:@selector(beganSearch) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:begainSearch];
    [self.view addSubview:headerView];
}

- (void)loadHorizontalScrollView{
    SVTopScrollView *topScrollView = [SVTopScrollView shareInstance];
    topScrollView.nameArray = @[@"全部", @"食材", @"菜谱", @"菜单", @"相克/宜搭", @"下雨", @"健康养生", @"eclipse", @"美食知识", @"美食贴",@"周琦落选", @"英国脱欧要挂了", @"龙卷风"]; //此处有bug，当传入的名字太长了，uiscorlView会出问题
    [self.view addSubview:topScrollView];
    [topScrollView initWithNameButtons];
}

- (void)assignmentSearchHistoryArray:(NSString *)string{
    //获取沙盒目录
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [filePath objectAtIndex:0];
    //获取完整的文件名
    NSString *fileName = [plistPath stringByAppendingPathComponent:@"history.plist"];
    //取出数据
    NSMutableArray *historyArray = [NSMutableArray arrayWithContentsOfFile:fileName];
    if (!historyArray) {
        historyArray = [[NSMutableArray alloc] init];
    }
    //判断输入的字符是否为空，是否为全空格
    if (![self isEmpty:string]) {
        for (int i = 0; i<historyArray.count; i++) {
            if ([string isEqualToString:historyArray[i]]) {
                for (int n = i; n > 0; n --) {
                    historyArray[n] = historyArray[n-1];
                }
                historyArray[0] = string;
                break;
            }
        }
        if(historyArray.count > 9){
            [historyArray removeObjectAtIndex:0];
        }
        [historyArray addObject:string];
        //写入plist文件
        [historyArray writeToFile:fileName atomically:YES];
    }
}

//判断字符是否全为空格
- (BOOL)isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (void)beganSearch{
    [self.searchBar resignFirstResponder];
    HTEAPI *api = [[HTEAPI alloc]init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (![self isEmpty:self.searchBar.text]) {
        [params setValue:self.searchBar.text forKey:@"menu"];
        [params setValue:@"0" forKey:@"rn"];
        [params setValue:@"3" forKey:@"pn"];
        
        //将搜索词条写入历史数据列表
        [self assignmentSearchHistoryArray:self.searchBar.text];
        [_historyView removeFromSuperview];
        [_activityView startAnimating];
        [api requestWithURL:kHTEAPIDomain params:params delegate:self];
    }else{
        CGRect rect = CGRectMake((self.view.bounds.size.width/2 - 50), self.view.bounds.size.height/2, 100, 20);
        self.alertText = [[UITextField alloc]initWithFrame:rect];
        self.alertText.backgroundColor = [UIColor blackColor];
        self.alertText.textColor = [UIColor whiteColor];
        self.alertText.textAlignment = NSTextAlignmentCenter;
        self.alertText.text = @"输入不能为空";
        self.alertText.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:self.alertText];
        [self performSelector:@selector(delayAction) withObject:nil afterDelay:1];
    }
}

- (void)initMenu{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, self.view.bounds.size.height - (headerViewHeight + 40)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [[NSArray alloc]init];
    if (self.resultDict != nil) {
        array = [[juheDataModel alloc]asignModelWithDict:self.resultDict];
    }
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    customTableViewCell *cell = (customTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"customTableViewCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"customTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    customTableViewCell *cell = (customTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"customTableViewCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"customTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSArray *array = [[NSArray alloc]init];
    if (self.resultDict != nil) {
        array = [[juheDataModel alloc]asignModelWithDict:self.resultDict];
    }
    
    [cell showUIWithModel:array[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [[NSArray alloc]init];
    if (self.resultDict != nil) {
        array = [[juheDataModel alloc]asignModelWithDict:self.resultDict];
    }
    juheDataModel *model = array[indexPath.row];
    
    //页面跳转传值
    stepViewController *stepVC = [[stepViewController alloc]init];
    stepVC.detailModel = model;
    [self.navigationController pushViewController:stepVC animated:YES];
}

- (void)delayAction{
    [self.alertText removeFromSuperview];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//数据请求成功代理方法
- (void)request:(HTERequest *)request didFinishLoadingWithResult:(id)result{
    if([_activityView isAnimating]){
        [_activityView stopAnimating];
    }
    [self initMenu];
    self.resultDict = result;
    juheDataModel *model = [[juheDataModel alloc]init];
    self.dataArray = [model asignModelWithDict:self.resultDict];
    NSLog(@"数组个数为：%ld----第一个菜单名为：%@",(unsigned long)self.dataArray.count, [self.dataArray[0]Title]);
    [self.tableView reloadData];
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)request:(HTERequest *)request didFailWithError:(NSError *)error{
    if ([_activityView isAnimating]) {
        [_activityView stopAnimating];
    }
    [MBProgressHUD showError:@"连接网络失败"];
}


- (void)tapViewToCustom:(UILabel*)label{
    NSLog(@"%@",label.text);
    HTEAPI *api = [[HTEAPI alloc]init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:label.text forKey:@"menu"];
    [params setValue:@"0" forKey:@"rn"];
    [params setValue:@"3" forKey:@"pn"];
    
    //将搜索词条写入历史数据列表
    [self assignmentSearchHistoryArray:label.text];
    [_historyView removeFromSuperview];
    [_hostSearchListView removeFromSuperview];
    [_activityView startAnimating];
    [api requestWithURL:kHTEAPIDomain params:params delegate:self];
}


//点击屏幕空白区域，收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
