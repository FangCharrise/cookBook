//
//  HTERequest.m
//  HowToEat
//
//  Created by FangZ on 16/6/17.
//  Copyright © 2016年 FangZ. All rights reserved.
//

#import "HTERequest.h"
#import "HTEConstants.h"
#import "HTEAPI.h"

@interface HTEAPI ()
- (void)requestDidFinish:(HTERequest *)request;
@end

@implementation HTERequest{
    NSURLConnection *_connection;
    NSMutableData   *_responseData;
}

- (NSMutableData *)postBodyHasRawData:(BOOL*)hasRawData
{
    return nil;
}


- (void)handleResponseData:(NSData *)data{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (result == nil) {
        [self failedWithError:error];
    } else {
        if ([_delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
        {
            [_delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
        }
    }
}

- (void)failedWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(request:didFailWithError:)])
    {
        [_delegate request:self didFailWithError:error];
    }
}

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            return nil;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}


+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params{
    NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
    
    if (params) {
        [paramsDic setValuesForKeysWithDictionary:params];
    }
    
    NSMutableString *AppKey = [NSMutableString stringWithString:testAppKey];
    NSMutableString *requestString = [NSMutableString stringWithFormat:@"%@",parsedURL];
    [requestString appendString:[NSString stringWithFormat:@"key=%@",testAppKey]];
    NSMutableString *urlString = [[NSMutableString stringWithFormat:@"&menu=%@",[paramsDic objectForKey:@"menu"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [requestString appendString:urlString];

    NSString *rnString = [NSString stringWithFormat:@"&rn=%@",[paramsDic objectForKey:@"rn"]];
    
    if (rnString.length == 0) {
        rnString = [NSString stringWithFormat:@"&rn=10"];
    }
    
    [requestString appendString:rnString];
    NSString *str = [NSString stringWithFormat:@"&pn=%@",[paramsDic objectForKey:@"pn"]];
    [requestString appendString:str];
    NSLog(@"%@",requestString);
    return requestString;
}


+ (HTERequest *)requestWithURL:(NSString *)url params:(NSDictionary *)params delegate:(id<HTERequestDelegate>)delegate{
    HTERequest *request = [[HTERequest alloc]init];
    
    request.url = url;
    request.params = params;
    request.delegate = delegate;
    
    return request;
}


- (void)connect{
    NSString* urlString = [[self class] serializeURL:_url params:_params];
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:kFYRequestTimeOutInterval];
    
    [request setHTTPMethod:@"GET"];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)disconnect{
    _responseData = nil;
    
    [_connection cancel];
    _connection = nil;
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
    
    if ([_delegate respondsToSelector:@selector(request:didReceiveResponse:)])
    {
        [_delegate request:self didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    [self handleResponseData:_responseData];
    
    _responseData = nil;
    
    [_connection cancel];
    _connection = nil;
    
    [_hteapi requestDidFinish:self];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self failedWithError:error];
    
    _responseData = nil;
    
    [_connection cancel];
    _connection = nil;
    
    [_hteapi requestDidFinish:self];
}

#pragma mark - Life Circle
- (void)dealloc
{
    [_connection cancel];
    _connection = nil;
}

@end
