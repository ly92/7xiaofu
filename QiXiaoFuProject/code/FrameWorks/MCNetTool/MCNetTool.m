//
//  MCNetTool.m
//  BeautifulFaceProject
//
//  Created by 冯 on 16/4/28.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "MCNetTool.h"
#import "MCHttp.h"

@implementation MCNetTool

+ (BOOL)net{
    return [MCHttp requestBeforeCheckNetWork];
}


+ (void)updateBaseUrl:(NSString *)baseUrl {
    [MCHttp updateBaseUrl:baseUrl];
}


+ (NSURLSessionTask * )getWithUrl:(NSString *)url
                           params:(NSDictionary *)parameters
                          success:(SuccessBlock)success
                             fail:(ErrorBlock)fail{
    
    
    return [MCHttp getRequestURLStr:url withDic:parameters  success:^(NSDictionary *requestDic, NSString *msg,BOOL hasmore,NSInteger page_total) {
        
        
        success(requestDic,msg);

        
    } failure:^(NSString *error) {
        
        fail(error);
    }];
}
 

+ (NSURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                           success:(SuccessBlock)success
                              fail:(ErrorBlock)fail{
    

    return [MCHttp postRequestURLStr:url withDic:params success:^(NSDictionary *requestDic, NSString *msg,BOOL hasmore,NSInteger page_total) {
        success(requestDic,msg);
    } failure:^(NSString *error) {
        DeLog(@"_________   %@",error);
        
        fail(error);
    }];
}







+ (NSURLSessionTask *)postWithCacheUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                success:(SuccessBlock)success
                                   fail:(ErrorBlock)fail{

    return [MCHttp postRequestCacheURLStr:url withDic:params success:^(NSDictionary *requestDic, NSString *msg,BOOL hasmore,NSInteger page_total) {
        
        
        
        success(requestDic,msg);
        
        
    } failure:^(NSString *error) {
         fail(error);
    }];
    
}


+ (NSURLSessionTask *)uploadDataWithURLStr:(NSString *)urlStr
                                   withDic:(NSDictionary *)pasameters
                                  imageKey:(NSString *)attach
                                  withData:(NSData *)data
                            uploadProgress:(progress)loadProgress
                                   success:(SuccessBlock)success
                                   failure:(ErrorBlock)failure{

    return [MCHttp uploadDataWithURLStr:urlStr withDic:pasameters imageKey:attach withData:data uploadProgress:^(float progress) {
        
        loadProgress(progress*100);
        
    } success:^(NSDictionary *requestDic, NSString *msg,BOOL hasmore,NSInteger page_total) {
        success(requestDic,msg);
    } failure:^(NSString *error) {
         failure(error);
    }];
}



+ (NSURLSessionTask *)postWithPageUrl:(NSString *)url
                               params:(NSDictionary *)params
                              success:(SuccessPageBlock)success
                                 fail:(ErrorBlock)fail{


    return [MCHttp postRequestURLStr:url withDic:params success:^(NSDictionary *requestDic, NSString *msg,BOOL hasmore,NSInteger page_total) {
        success(requestDic,msg,hasmore,page_total);
    } failure:^(NSString *error) {
        DeLog(@"_________   %@",error);
        
        fail(error);
    }];

}

+ (NSURLSessionTask *)postWithCachePageUrl:(NSString *)url
                                    params:(NSDictionary *)params
                                   success:(SuccessPageBlock)success
                                      fail:(ErrorBlock)fail{


    return [MCHttp postRequestCacheURLStr:url withDic:params success:^(NSDictionary *requestDic, NSString *msg,BOOL hasmore,NSInteger page_total) {
        
        
        
        success(requestDic,msg,hasmore,page_total);
        
        
    } failure:^(NSString *error) {
        DeLog(@"_________   %@",error);
        fail(error);
    }];


}



















@end
