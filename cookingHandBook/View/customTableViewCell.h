//
//  customTableViewCell.h
//  HowToEat
//
//  Created by FangZ on 16/6/22.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class juheDataModel;

@interface customTableViewCell : UITableViewCell

- (void)showUIWithModel:(juheDataModel *)model;

@end
