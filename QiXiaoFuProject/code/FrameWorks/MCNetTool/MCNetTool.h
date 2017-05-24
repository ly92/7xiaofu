//
//  MCNetTool.h
//  BeautifulFaceProject
//
//  Created by 冯 on 16/4/28.
//  Copyright © 2016年 冯洪建. All rights reserved.
//  直接拿来用的网络工具类

#import <Foundation/Foundation.h>


typedef void(^SuccessBlock)(NSDictionary * requestDic,NSString * msg);
typedef void(^SuccessPageBlock)(NSDictionary * requestDic,NSString * msg,BOOL hasmore,NSInteger page_total);
typedef void(^ErrorBlock)(NSString *error);
typedef void(^progress)(float progress);

@interface MCNetTool : NSObject

+ (BOOL)net;
+ (void)updateBaseUrl:(NSString *)baseUrl;

+ (NSURLSessionTask * )getWithUrl:(NSString *)url
                         params:(NSDictionary *)parameters
                          success:(SuccessBlock)success
                             fail:(ErrorBlock)fail;


+ (NSURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(SuccessBlock)success
                             fail:(ErrorBlock)fail;

+ (NSURLSessionTask *)postWithPageUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(SuccessPageBlock)success
                             fail:(ErrorBlock)fail;

+ (NSURLSessionTask *)postWithCachePageUrl:(NSString *)url
                                params:(NSDictionary *)params
                               success:(SuccessPageBlock)success
                                  fail:(ErrorBlock)fail;


+ (NSURLSessionTask *)postWithCacheUrl:(NSString *)url
                                params:(NSDictionary *)params
                               success:(SuccessBlock)success
                                  fail:(ErrorBlock)fail;

+ (NSURLSessionTask *)uploadDataWithURLStr:(NSString *)urlStr
                                   withDic:(NSDictionary *)pasameters
                                  imageKey:(NSString *)attach
                                  withData:(NSData *)data
                            uploadProgress:(progress)loadProgress
                                   success:(SuccessBlock)success
                                   failure:(ErrorBlock)failure;
@end
