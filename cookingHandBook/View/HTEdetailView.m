//
//  HTEdetailView.m
//  tableViewProject
//
//  Created by FangZ on 16/7/7.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import "HTEdetailView.h"
#import "UIImageView+WebCache.h"

#define screenWidth     320
#define labelWidth      self.frame.size.width-30
#define DEBUG_Test      0

@implementation HTEdetailView

@synthesize detailModel;


//+ (HTEdetailView *)shareInstance{
//    static HTEdetailView *_instance;
//    static dispatch_once_t oncetoken;
//    dispatch_once(&oncetoken, ^{
//        _instance = [[self alloc]initWithFrame:CGRectMake(0, 64, screenWidth, 568)];
//    });
//    return _instance;
//}

- (instancetype)init{
    if(self = [super init]){
        self.frame = CGRectMake(0, 64, screenWidth, 568);
//        [super initWithFrame:CGRectMake(0, 64, screenWidth, 568)]
    }
    return self;
}

- (void)initDetailView{
    //滑动条不显示
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    scrollViewContentSizeY = 0;
    //添加顶部的imageView
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, scrollViewContentSizeY, screenWidth, 210)];
    NSLog(@"%@",detailModel.albums);
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:[detailModel.albums objectAtIndex:0]]];
    [self addSubview:headerImageView];
    
    //添加title
    scrollViewContentSizeY += (headerImageView.bounds.size.height + 15);
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, labelWidth, 30)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    titleLabel.text = detailModel.Title;
    [self addSubview:titleLabel];
    
    //添加心得experence
    scrollViewContentSizeY += (titleLabel.bounds.size.height + 15);
    UILabel *experence = [[UILabel alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, labelWidth, 30)];
    experence.textColor = [UIColor blackColor];
    experence.text = @"心得";
    experence.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self addSubview:experence];
    
    //添加心得详情
    scrollViewContentSizeY += (experence.bounds.size.height + 15);
    UILabel *experenceDetailLabel = [[UILabel alloc]init];
    experenceDetailLabel.text = detailModel.imtro;      //从模型中取值
    experenceDetailLabel.numberOfLines = 0;
    experenceDetailLabel.font = [UIFont fontWithName:@"Arial" size:14];
    NSDictionary *attrDic = @{NSFontAttributeName: experenceDetailLabel.font};
    int labelHeight = [experenceDetailLabel.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrDic context:nil].size.height + 2;
    experenceDetailLabel.frame = CGRectMake(15, scrollViewContentSizeY, labelWidth, labelHeight);
    experenceDetailLabel.textColor = [UIColor blackColor];
    [self addSubview:experenceDetailLabel];
    
    //
    scrollViewContentSizeY += labelHeight + 20;
    UILabel *ingredientsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, labelWidth, 30)];
    ingredientsLabel.textColor = [UIColor blackColor];
    ingredientsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    ingredientsLabel.text = @"用料";
    [self addSubview:ingredientsLabel];
    
    //添加食材列表
    scrollViewContentSizeY += (ingredientsLabel.bounds.size.height + 15);
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, labelWidth, 1)];
    lineView1.layer.borderWidth = 1;
    lineView1.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2].CGColor;
    [self addSubview:lineView1];
    UILabel *mainIngredLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, labelWidth, 45)];
    mainIngredLabel.font = [UIFont fontWithName:@"Arial" size:14];
    mainIngredLabel.textColor = [UIColor blackColor];
    mainIngredLabel.text = detailModel.ingredients;
//    mainIngredLabel.text = @"五花肉    500g";
    [self addSubview:mainIngredLabel];
    
    scrollViewContentSizeY += mainIngredLabel.bounds.size.height;
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, labelWidth, 1)];
    lineView2.layer.borderWidth = 1;
    lineView2.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2].CGColor;
    [self addSubview:lineView2];

    //添加佐料列表
    [self addBurdenListView];
    
    //添加步骤
    scrollViewContentSizeY += 15;
    UILabel *stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, labelWidth, 40)];
    stepLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    stepLabel.text = @"做法";
    [self addSubview:stepLabel];
    
    [self addStepsView];
    
    scrollViewContentSizeY += 40;
    self.contentSize = CGSizeMake(320, scrollViewContentSizeY + 15);
}

- (void)addBurdenListView{
    //字符串处理
    NSString *list = detailModel.burden;
    NSArray *comArr = [list componentsSeparatedByString:@";"];
    for (int i = 0; i < [comArr count]; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, labelWidth, 1)];
        line.layer.borderWidth = 1;
        line.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2].CGColor;
        [self addSubview:line];
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, 180, 40)];
        name.font = [UIFont fontWithName:@"Arial" size:14];
        UILabel *amount = [[UILabel alloc]initWithFrame:CGRectMake(200, scrollViewContentSizeY, 105, 40)];
        amount.font = [UIFont fontWithName:@"Arial" size:14];
        [self addSubview:amount];
        [self addSubview:name];
        NSArray *cell = [[comArr objectAtIndex:i] componentsSeparatedByString:@","];
        name.text = [cell objectAtIndex:0];
        amount.text = [cell objectAtIndex:1];
        scrollViewContentSizeY += 40;
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, labelWidth, 1)];
    line.layer.borderWidth = 1;
    line.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2].CGColor;
    [self addSubview:line];
}


- (void)addStepsView{
    NSArray *stepsArray = detailModel.steps;
    scrollViewContentSizeY += (40 + 15);
    for (int i = 0; i< [stepsArray count]; i++) {
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[stepsArray objectAtIndex:i]];
        NSString *step = [dic objectForKey:@"step"];
        UILabel *stepDescribeLabel = [[UILabel alloc]init];
        [stepDescribeLabel setNumberOfLines:0];
        stepDescribeLabel.font = [UIFont fontWithName:@"Arial" size:14];
        NSDictionary *attrDic = @{NSFontAttributeName: stepDescribeLabel.font};
        int labelHeight = [step boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrDic context:nil].size.height + 2;
        stepDescribeLabel.frame = CGRectMake(15, scrollViewContentSizeY, labelWidth, labelHeight);
        stepDescribeLabel.text = step;
        [self addSubview:stepDescribeLabel];
        
        
        scrollViewContentSizeY += (stepDescribeLabel.bounds.size.height + 5);
        UIImageView *stepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, scrollViewContentSizeY, 145, 80)];
        [stepImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]]];
        [self addSubview:stepImageView];
        scrollViewContentSizeY += 80 + 15;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
