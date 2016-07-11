//
//  HTERequest.h
//  HowToEat
//
//  Created by FangZ on 16/6/17.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTEAPI;
@protocol HTERequestDelegate;

@interface HTERequest : NSObject

//请求参数key，必填参数--注册领取appkey
@property (strong, nonatomic)NSString * key;

//请求参数menu，必填参数--餐单名称
@property (strong, nonatomic)NSString * menu;

//请求返回餐单的数目，最大值为30
@property (strong, nonatomic)NSString * rn; //max value 30;

@property (nonatomic, unsafe_unretained) HTEAPI *hteapi;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, unsafe_unretained) id<HTERequestDelegate> delegate;

+ (HTERequest *)requestWithURL:(NSString *)url
                       params:(NSDictionary *)params
                     delegate:(id<HTERequestDelegate>)delegate;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;

- (void)connect;

- (void)disconnect;

@end

@protocol HTERequestDelegate <NSObject>

@optional

- (void)request:(HTERequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(HTERequest *)request didReceiveRawData:(NSData *)data;
- (void)request:(HTERequest *)request didFailWithError:(NSError *)error;
- (void)request:(HTERequest *)request didFinishLoadingWithResult:(id)result;

@end
