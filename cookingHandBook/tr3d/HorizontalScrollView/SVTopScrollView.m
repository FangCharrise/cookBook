//
//  SVTopScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "SVTopScrollView.h"
#import "SVGloble.h"
#import "SVRootScrollView.h"


//按钮空隙
#define BUTTONGAP 15
//滑条宽度
#define CONTENTSIZEX 320
//按钮id
#define BUTTONID (sender.tag-100)
//滑动id
#define BUTTONSELECTEDID (scrollViewSelectedChannelID - 100)
//设定字体大小
#define fountSize   14.0f


@implementation SVTopScrollView

@synthesize nameArray;
@synthesize scrollViewSelectedChannelID;

+ (SVTopScrollView *)shareInstance {
    static SVTopScrollView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] initWithFrame:CGRectMake(0, 55, CONTENTSIZEX, 40)];//IOS7_STATUS_BAR_HEGHT
    });
    return _instance;
}


- (id)initWithFrame:(CGRect)frame
{
    buttonWithArray = [[NSMutableArray alloc]init];
    buttonArray = [[NSMutableArray alloc]init];
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.buttonOriginXArray = [NSMutableArray array];
        buttonWithArray = [NSMutableArray array];
    }
    return self;
}

- (void)initWithNameButtons
{
    static int defaultSlectedBtn = 2;
    scrollViewContentSizeX = 10.0;
    userSelectedChannelID = 102;
    scrollViewSelectedChannelID = 102;
    
    UIButton *button;
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
    for (int i = 0; i<[buttonArray count]; ++i) {
        button = (UIButton *)[buttonArray objectAtIndex:i];
        NSString *string = [NSString stringWithFormat:@"%@",button.currentTitle];
        NSLog(@"%@",string);
        [button removeFromSuperview];
    }
    [shadowImageView removeFromSuperview];
    [buttonArray removeAllObjects];
    
    for (int i = 0; i < [self.nameArray count]; i++) {
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [self.nameArray objectAtIndex:i];
        
        [button setTag:i+100];
        if (i == defaultSlectedBtn) {
            button.selected = YES;
        }
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:fountSize];
        [button.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[SVGloble colorFromHexRGB:@"bb0b15"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //iOS7之后推荐用一下方法获取文本框的尺寸
        NSDictionary *attrDic = @{NSFontAttributeName:[UIFont systemFontOfSize:fountSize]};
        int buttonWidth = [title boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDic context:nil].size.width + 2;
        button.frame = CGRectMake(scrollViewContentSizeX, 9, buttonWidth, 30);
//        NSLog(@"第%d个按钮的宽度为:%f",i ,button.frame.size.width);
        [_buttonOriginXArray addObject:@(scrollViewContentSizeX)];
        
        scrollViewContentSizeX += buttonWidth+BUTTONGAP;

        [buttonWithArray addObject:@(button.frame.size.width)];
        [buttonArray addObject:button];
        [self addSubview:button];
    }
    self.contentSize = CGSizeMake(scrollViewContentSizeX, 40);
    int x =[[_buttonOriginXArray objectAtIndex:defaultSlectedBtn] floatValue];
    shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, [[buttonWithArray objectAtIndex:defaultSlectedBtn] floatValue], 40)];
    [shadowImageView setImage:[UIImage imageNamed:@"red_line_and_shadow.png"]];
    [self addSubview:shadowImageView];
}

//点击顶部条滚动标签
- (void)selectNameButton:(UIButton *)sender
{
    [self adjustScrollViewContentX:sender];
    //如果更换按钮
    if (sender.tag != userSelectedChannelID) {
        //取之前的按钮
//        NSLog(@"选中的按钮为：%ld",sender.tag);
//        NSLog(@"选中之前的按钮是：%ld",userSelectedChannelID);
        UIButton *lastButton = (UIButton *)[self viewWithTag:userSelectedChannelID];
        if (lastButton.selected == YES) {
            lastButton.selected = NO;
        }
        //赋值按钮ID
        userSelectedChannelID = sender.tag;
        scrollViewSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
//    NSLog(@"%ld",sender.tag);
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            
            [shadowImageView setFrame:CGRectMake(sender.frame.origin.x, 0, [[buttonWithArray objectAtIndex:BUTTONID] floatValue], 40)];
            
        } completion:^(BOOL finished) {
            if (finished) {
                //设置新闻页出现
                [[SVRootScrollView shareInstance] setContentOffset:CGPointMake(BUTTONID*320, 0) animated:YES];
                //赋值滑动列表选择频道ID
                scrollViewSelectedChannelID = sender.tag;
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        
    }
}

- (void)adjustScrollViewContentX:(UIButton *)sender
{
    float originX = [[_buttonOriginXArray objectAtIndex:BUTTONID] floatValue];
    float width = [[buttonWithArray objectAtIndex:BUTTONID] floatValue];
    float superViewHalfWidth = self.superview.bounds.size.width/2;
    if (originX > superViewHalfWidth) {
        [self setContentOffset:CGPointMake((originX - superViewHalfWidth) + width/2, 0) animated:YES];
    }else if (self.contentOffset.x > 0){
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if ((self.contentSize.width - originX) < superViewHalfWidth) {
        [self setContentOffset:CGPointMake(self.contentSize.width - self.superview.frame.size.width, 0) animated:YES];
    }
}

//滚动内容页顶部滚动
- (void)setButtonUnSelect
{
    //滑动撤销选中按钮
    UIButton *lastButton = (UIButton *)[self viewWithTag:scrollViewSelectedChannelID];
    lastButton.selected = NO;
}

- (void)setButtonSelect
{
    NSLog(@"%ld",(long)scrollViewSelectedChannelID);
    //滑动选中按钮
    UIButton *button = (UIButton *)[self viewWithTag:scrollViewSelectedChannelID];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [shadowImageView setFrame:CGRectMake(button.frame.origin.x, 0, [[buttonWithArray objectAtIndex:button.tag-100] floatValue], 40)];
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (!button.selected) {
                button.selected = YES;
                userSelectedChannelID = button.tag;
            }
        }
    }];
    
}

-(void)setScrollViewContentOffset
{
    float originX = [[_buttonOriginXArray objectAtIndex:BUTTONSELECTEDID] floatValue];
    float width = [[buttonWithArray objectAtIndex:BUTTONSELECTEDID] floatValue];
    if (originX - self.contentOffset.x > CONTENTSIZEX-(BUTTONGAP+width)) {
        [self setContentOffset:CGPointMake(originX - 30, 0)  animated:YES];
    }
    
    if (originX - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(originX,0)  animated:YES];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
