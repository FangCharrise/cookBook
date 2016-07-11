//
//  searchHistoryModel.h
//  HowToEat
//
//  Created by FangZ on 16/7/5.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface searchHistoryModel : NSObject

@property (strong, nonatomic)NSArray * historyArray;

- (NSArray *)loadSearchHistory:(NSString *)string;

@end
