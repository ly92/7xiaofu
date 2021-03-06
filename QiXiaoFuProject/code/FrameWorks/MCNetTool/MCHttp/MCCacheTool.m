//
//  MCCacheTool.m
//  AFNetworkingDemo
//
//  Created by 冯洪建 on 15/12/17.
//  Copyright (c) 2015年 冯洪建. All rights reserved.
//


/*!
 *  缓存的策略：(如果 cacheTime == 0，将永久缓存数据) 也就是缓存的时间 以 秒 为单位计算
 *  分钟 ： 60
 *  小时 ： 60 * 60
 *  一天 ： 60 * 60 * 24
 *  星期 ： 60 * 60 * 24 * 7
 *  一月 ： 60 * 60 * 24 * 30
 *  一年 ： 60 * 60 * 24 * 365
 *  永远 ： 0
 */
static NSInteger const cacheTime = 0 ; 


/**
 缓存的有效期  单位是s
 */
#define kYBCache_Expire_Time (3600*24)


// 缓存路径  缓存到Caches目录  统一做计算缓存大小，以及删除缓存操作
// NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
#define kCachePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])


#import "MCCacheTool.h"
#import "FMDB.h"
#import "CommonCrypto/CommonDigest.h"

static FMDatabaseQueue *_queue;

@implementation MCCacheTool

+(void)initialize{
    NSString * bundleName =[[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleNameKey];
    NSString *dbName=[NSString stringWithFormat:@"%@%@",bundleName,@".sqlite"];
    NSString *filename = [kCachePath stringByAppendingPathComponent:dbName];
    _queue=[FMDatabaseQueue databaseQueueWithPath:filename];
    //创建表
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS MCData (id integer PRIMARY KEY AUTOINCREMENT, url text NOT NULL, data blob NOT NULL,savetime date);"];
        if(!result){
#ifdef DEBUG
            NSLog(@"创建表失败");
#endif
        }
    }];
}
+ (void)saveData:(NSData *)data url:(NSString *)url{
    
     [_queue inDatabase:^(FMDatabase *db) {
         FMResultSet *rs = [db executeQuery:@"SELECT * FROM MCData WHERE url = ?",url];
        if([rs next]){
            BOOL res  =[db executeUpdate: @"update MCData set data =?,savetime =? where url = ?",data,[NSDate date],url];
#ifdef DEBUG
            NSLog(@"\n\n%@     %@\n\n",url,res?@"数据更新成功":@"数据更新失败");
#endif
        }else{
            BOOL res =  [db executeUpdate:@"INSERT INTO MCData (url,data,savetime) VALUES (?,?,?);",url, data,[NSDate date]];
#ifdef DEBUG
            NSLog(@"\n\n%@     %@\n\n",url,res?@"数据插入成功":@"数据插入失败");
#endif
        }
         [rs close];
     }];
 }

#pragma mark --通过请求参数去数据库中加载对应的数据
+ (NSData *)cachedDataWithUrl:(NSString *)url{
   __block NSData * data = [[NSData alloc]init];
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = nil;
        resultSet = [db executeQuery:@"SELECT * FROM MCData WHERE url = ?", url];
        // 遍历查询结果
        while (resultSet.next) {
            NSDate *  time = [resultSet dateForColumn:@"savetime"];
            NSTimeInterval timeInterval = -[time timeIntervalSinceNow];
            if(timeInterval > cacheTime &&  cacheTime!= 0){
                NSLog(@"\n\n     %@     \n\n",@"缓存的数据过期了");
            }else{
                data = [resultSet objectForColumnName:@"data"];
            }
        }
    }];
     return data;
}


#pragma mark 删除对应的数据
+ (void)deleteDataWithUrl:(NSString*)url{
    [_queue inDatabase:^(FMDatabase *db) {
        //delete from info where idstr='T1348648517839'
        BOOL b=[db executeUpdate:@"delete  from MCData where url=?",url];
        if(!b){
#ifdef DEBUG
            NSLog(@"删除失败");
#endif
        }
    }];
}


#pragma mark ---   计算一共缓存的数据的大小
+ (NSString *)cacheSize{
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSArray *subpaths = [mgr subpathsAtPath:kCachePath];
    CGFloat ttotalSize = 0;
    for (NSString *subpath in subpaths) {
        NSString *fullpath = [kCachePath stringByAppendingPathComponent:subpath];
        BOOL dir = NO;
        [mgr fileExistsAtPath:fullpath isDirectory:&dir];
        if (dir == NO) {// 文件
            ttotalSize += [[mgr attributesOfItemAtPath:fullpath error:nil][NSFileSize] longLongValue];
        }
    }//  M
    ttotalSize = ttotalSize/1024;
    return ttotalSize<1024?[NSString stringWithFormat:@"%.1f KB",ttotalSize]:[NSString stringWithFormat:@"%.1f MB",ttotalSize/1024];
}
/**
 *  获取文件大小
 */
+ (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}
#pragma mark ---   清空缓存的数据
+ (void)deleateCache:(clearSuccess)clearSuccess{

    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSError *error;
                       
                       //                       BOOL  res =  [[NSFileManager defaultManager] removeItemAtPath:cachPath error:&error];
                       //#ifdef DEBUG
                       //                       NSLog(@"\n\n---%@----\n\n",res?@"成功":@"失败");
                       //#endif
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       //NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               BOOL  res =  [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               
                               clearSuccess();
                               
                               
#ifdef DEBUG
                               NSLog(@"\n\n---%@----\n\n",res?@"成功":@"失败");
#endif
                           }
                       }
                   });
 
}


#pragma mark ---
#pragma mark ---  清除缓存文件

+(void)myClearCacheAction{
    
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSError *error;

//                       BOOL  res =  [[NSFileManager defaultManager] removeItemAtPath:cachPath error:&error];
//#ifdef DEBUG
//                       NSLog(@"\n\n---%@----\n\n",res?@"成功":@"失败");
//#endif
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       //NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                            NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                              BOOL  res =  [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               
 #ifdef DEBUG
                               NSLog(@"\n\n---%@----\n\n",res?@"成功":@"失败");
#endif
                            }
                       }
                   });

}





+ (void)cacheForData:(NSData *)data fileName:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:[self md5:fileName]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:path atomically:YES];
    });
}

+ (NSData *)getCacheFileName:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:[self md5:fileName]];
    return [[NSData alloc] initWithContentsOfFile:path];
}

+ (NSUInteger)getAFNSize
{
    NSUInteger size = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:kCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [kCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

+ (NSUInteger)getSize
{
    //获取AFN的缓存大小
    NSUInteger afnSize = [self getAFNSize];
    return afnSize;
}

+ (void)clearAFNCache
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:kCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [kCachePath stringByAppendingPathComponent:fileName];
        
        [fm removeItemAtPath:filePath error:nil];
        
    }
}

+ (void)clearCache
{
    [self clearAFNCache];
}

+ (BOOL)isExpire:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:[self md5:fileName]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attributesDict = [fm attributesOfItemAtPath:path error:nil];
    NSDate *fileModificationDate = attributesDict[NSFileModificationDate];
    NSTimeInterval fileModificationTimestamp = [fileModificationDate timeIntervalSince1970];
    //现在的时间戳
    NSTimeInterval nowTimestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    return ((nowTimestamp-fileModificationTimestamp)>kYBCache_Expire_Time);
}


+ (NSString *)md5:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}




@end
