//
//  FileManager.h
//  hengyingpayapp
//
//  Created by hengyingpay on 16/1/4.
//  Copyright © 2016年 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject
+(FileManager*)shareManager;
+(NSString*)filePathWithFileName:(NSString*)fileName;
+(NSData*)loadFileWithFileName:(NSString*)fileName;
+(BOOL)saveFileWithFileName:(NSString*)fileName fileInfo:(NSString*)fileInfo;
+(BOOL)deleteFileWithFileName:(NSString*)fileName;

@end
