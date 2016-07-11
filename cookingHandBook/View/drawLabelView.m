//
//  drawLabelView.m
//  UITextLabel
//
//  Created by FangZ on 16/7/4.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import "drawLabelView.h"

#define titleLabelHeigth        35
#define screenWidth             320
#define labelHeigth             40

@implementation drawLabelView

- (instancetype)initWithFrame:(CGRect)frame withHistory:(NSArray *)historyArray title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.historyRow = (int)historyArray.count/3;
        if ((historyArray.count %3)>0) {
            self.historyRow += 1;
        }
        if (self.historyRow > 3) {
            self.historyRow = 3;
        }
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, screenWidth, titleLabelHeigth + self.historyRow * labelHeigth);
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, titleLabelHeigth)];
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:titleLabel];
        int cellCount = 0;
        static int labelBaseTag = 1000;
        for (int j = 0; j < self.historyRow; j++) {
            for (int i = 0; i < 3; i++) {
                if (cellCount < historyArray.count) {
                    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake((i%3) * 106, titleLabelHeigth + labelHeigth * j, 107, labelHeigth)];
                    textLabel.text = historyArray[cellCount];
                    cellCount+= 1;
                    labelBaseTag += 1;
                    textLabel.tag = labelBaseTag;
                    textLabel.userInteractionEnabled = YES;
                    textLabel.textAlignment = NSTextAlignmentCenter;
                    textLabel.font = [UIFont systemFontOfSize:14.f];
                    UITapGestureRecognizer *tapedGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClicked:)];
                    [textLabel addGestureRecognizer:tapedGesture];
                    [self addSubview:textLabel];
                }
            }
        }
        [self drawLine];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawLine{
    for (int i = 0; i < self.historyRow; i++) {
        UIView *HLine = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabelHeigth + i * labelHeigth, screenWidth, 1)];
        HLine.layer.borderWidth = 1;
        HLine.layer.borderColor = [[[UIColor lightGrayColor]colorWithAlphaComponent:0.2] CGColor];
        UIView *VLine1 = [[UIView alloc]initWithFrame:CGRectMake(106, titleLabelHeigth + i * labelHeigth, 1, labelHeigth)];
        VLine1.layer.borderWidth = 1;
        VLine1.layer.borderColor = [[[UIColor lightGrayColor]colorWithAlphaComponent:0.2] CGColor];
        UIView *VLine2 = [[UIView alloc]initWithFrame:CGRectMake(213, titleLabelHeigth + i * labelHeigth, 1, labelHeigth)];
        VLine2.layer.borderWidth = 1;
        VLine2.layer.borderColor = [[[UIColor lightGrayColor]colorWithAlphaComponent:0.2] CGColor];
        [self addSubview:HLine];
        [self addSubview:VLine1];
        [self addSubview:VLine2];
    }
}

- (void)labelClicked:(UITapGestureRecognizer *)gestrue{
    UILabel *label = (UILabel *)gestrue.view;
    if ([self.labelTpedDelegate respondsToSelector:@selector(tapViewToCustom:)]) {
        [self.labelTpedDelegate tapViewToCustom:label];
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
