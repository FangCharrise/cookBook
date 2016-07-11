//
//  HTEdetailView.h
//  tableViewProject
//
//  Created by FangZ on 16/7/7.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "juheDataModel.h"

@interface HTEdetailView : UIScrollView{
    juheDataModel *detailModel;
    float scrollViewContentSizeY;
}

@property (nonatomic, retain) juheDataModel *detailModel;


//+ (HTEdetailView *)shareInstance;

/**
 *  加载视图
 */
- (void)initDetailView;

@end
