//
//  HTEAPI.h
//  HowToEat
//
//  Created by FangZ on 16/6/17.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTERequest.h"
#import "HTEConstants.h"

#define testAppKey  @"c849bdc55369e8ed5033186b0d0d2ad2"

@interface HTEAPI : NSObject



- (HTEAPI *)requestWithURL:(NSString *)url
                   params:(NSMutableDictionary *)params
                 delegate:(id<HTERequestDelegate>)delegate;

- (HTEAPI *)requestWithURL:(NSString *)url
             paramsString:(NSString *)paramsString
                 delegate:(id<HTERequestDelegate>)delegate;

@end
