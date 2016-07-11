//
//  juheDataModel.h
//  HowToEat
//
//  Created by FangZ on 16/6/21.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface juheDataModel : NSObject

@property (nonatomic, copy)NSString *resultcode;

@property (nonatomic, copy)NSString *reason;

@property (nonatomic, copy)NSArray *data;

@property (nonatomic, copy)NSString *idNumber;

@property (nonatomic, copy)NSString *Title;

@property (nonatomic, copy)NSString *Tags;;

@property (nonatomic, copy)NSString *imtro;

@property (nonatomic, copy)NSString *ingredients;

@property (nonatomic, copy)NSString *burden;

@property (nonatomic, copy)NSArray *albums;

@property (nonatomic, copy)NSArray *steps;

@property (nonatomic, copy)NSString *img;

@property (nonatomic, copy)NSString *step;;

@property (nonatomic, copy)NSString *totalNum;

@property (nonatomic, copy)NSString *pn;

@property (nonatomic, copy)NSString *rn;

@property (nonatomic, copy)NSString *error_code;

- (NSArray *)asignModelWithDict:(NSDictionary *)dict;

- (NSArray *)asignModelWithFile:(NSString *)fileName fileType:(NSString *)type;

@end
