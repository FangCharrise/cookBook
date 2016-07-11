//
//  juheDataModel.m
//  HowToEat
//
//  Created by FangZ on 16/6/21.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import "juheDataModel.h"

@implementation juheDataModel

- (NSArray *)asignModelWithDict:(NSDictionary *)dict{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSDictionary *dictResult = [NSDictionary dictionaryWithDictionary:[dict objectForKey:@"result"]];
    NSArray *dataArray = [dictResult objectForKey:@"data"];
    for (NSDictionary *dictData in dataArray) {
        juheDataModel *model = [[juheDataModel alloc]init];
        model.albums = dictData[@"albums"];
        model.burden = dictData[@"burden"];
        model.imtro = dictData[@"imtro"];
        model.ingredients = dictData[@"ingredients"];
        model.steps = dictData[@"steps"];
        model.Tags = dictData[@"tags"];
        model.Title = dictData[@"title"];
        [resultArray addObject:model];
    }
    return resultArray;
}


- (NSArray *)asignModelWithFile:(NSString *)fileName fileType:(NSString *)type{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:type];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    NSArray *dataArray = [dict objectForKey:@"result"];
    for (NSDictionary *dictData in dataArray) {
        juheDataModel *model = [[juheDataModel alloc]init];
        model.albums = dictData[@"albums"];
        model.burden = dictData[@"burden"];
        model.imtro = dictData[@"imtro"];
        model.ingredients = dictData[@"ingredients"];
        model.steps = dictData[@"steps"];
        model.Tags = dictData[@"tags"];
        model.Title = dictData[@"title"];
        [resultArray addObject:model];
    }
    return resultArray;
}

@end
