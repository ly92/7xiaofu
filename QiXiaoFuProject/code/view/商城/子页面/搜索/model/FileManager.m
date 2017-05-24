//
//  FileManager.m
//  hengyingpayapp
//
//  Created by hengyingpay on 16/1/4.
//  Copyright © 2016年 Coding. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager
+(FileManager*)shareManager
{
    static FileManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

+(NSData*)loadFileWithFileName:(NSString*)fileName
{
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSString* path = [FileManager filePathWithFileName:fileName];
    
    DeLog(@"获取：%@",[NSString stringWithFormat:@"%@",path]);

    //文件如果存在
    if ([fm fileExistsAtPath:path])
    {
        NSData* data = [[NSData alloc] init];
        data = [fm contentsAtPath:path];
        return data;
    }
    
    return nil;
}

+(NSString*)filePathWithFileName:(NSString*)fileName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* thepath = [paths lastObject];
    thepath = [thepath stringByAppendingPathComponent:fileName];
    DeLog(@"%@",thepath);
    return thepath;
}

+(BOOL)saveFileWithFileName:(NSString*)fileName fileInfo:(NSString*)fileInfo
{
    NSError* error = [[NSError alloc] init];
    
    NSString* path = [FileManager filePathWithFileName:fileName];
    
    DeLog(@"保存：%@",[NSString stringWithFormat:@"%@",path]);
    
    BOOL isSuccessBool = [fileInfo writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    return isSuccessBool;
}

+(BOOL)deleteFileWithFileName:(NSString*)fileName
{
    NSError* error = [[NSError alloc] init];
    
    NSString* path = [FileManager filePathWithFileName:fileName];
    
    DeLog(@"保存：%@",[NSString stringWithFormat:@"%@",path]);
    
    NSFileManager* fm = [NSFileManager defaultManager];

    BOOL isSuccessBool = [fm removeItemAtPath:path error:&error];
    
    return isSuccessBool;
}

@end
