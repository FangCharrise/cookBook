//
//  HTEAPI.m
//  HowToEat
//
//  Created by FangZ on 16/6/17.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import "HTEAPI.h"

@interface HTEAPI (Private)

@end

@implementation HTEAPI{
    NSMutableSet *requests;
}

- (id)init{
    self = [super init];
    if (self) {
        requests = [[NSMutableSet alloc]init];
    }
    return self;
}


- (HTERequest *)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params delegate:(id<HTERequestDelegate>)delegate{
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    //    NSString *fullURL = [kFYAPIDomain stringByAppendingString:url];
    HTERequest *_request = [HTERequest requestWithURL:url params:params delegate:delegate];
    
    _request.hteapi = self;
    [requests addObject:_request];
    [_request connect];
    return _request;
}

- (HTEAPI *)requestWithURL:(NSString *)url paramsString:(NSString *)paramsString delegate:(id<HTERequestDelegate>)delegate{
    return [self requestWithURL:[NSString stringWithFormat:@"%@%@",url, paramsString] params:nil delegate:delegate];
}

- (void)requestDidFinish:(HTERequest *)request
{
    [requests removeObject:request];
    request.hteapi = nil;
}

- (void)dealloc
{
    for (HTERequest* _request in requests)
    {
        _request.hteapi = nil;
    }
}

@end