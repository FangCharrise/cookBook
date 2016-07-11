//
//  searchHistoryModel.m
//  HowToEat
//
//  Created by FangZ on 16/7/5.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import "searchHistoryModel.h"

@implementation searchHistoryModel

- (NSArray *)loadSearchHistory:(NSString *)string{
    NSMutableArray *historyArray = [[NSMutableArray alloc]init];
    [historyArray addObject:string];
    NSArray *array = [NSArray arrayWithArray:historyArray];
    return array;
}

@end
