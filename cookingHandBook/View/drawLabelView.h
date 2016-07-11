//
//  drawLabelView.h
//  UITextLabel
//
//  Created by FangZ on 16/7/4.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tapedLabelDelegate <NSObject>

/**
 *  点击view
 *
 *  @param view
 */
@optional

- (void)tapViewToCustom:(UILabel*)label;

@end

@interface drawLabelView : UIView

@property (assign, nonatomic)NSInteger historyRow;

- (instancetype)initWithFrame:(CGRect)frame withHistory:(NSArray *)historyArray title:(NSString *)title;

@property (weak) IBOutlet id<tapedLabelDelegate>labelTpedDelegate;

@end
