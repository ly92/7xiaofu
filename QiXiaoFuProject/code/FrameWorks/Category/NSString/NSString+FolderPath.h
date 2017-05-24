//
//  NSString+FolderPath.h
//  TomtaoProject
//
//  Created by MiniC on 15/7/18.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FolderPath)


/*
 *  document根文件夹
 *  eg:  最常用的目录，iTunes同步该应用时会同步此文件夹中的内容，适合存储重要数据。
 */
+(NSString *)documentFolder;


/*
 *  caches根文件夹
 *  eg:  Library/Caches: iTunes不会同步此文件夹，适合存储体积大，不需要备份的非重要数据
 */
+(NSString *)cachesFolder;


/*
 *  tmp根文件夹
 *  eg: iTunes不会同步此文件夹，系统可能在应用没运行时就删除该目录下的文件，所以此目录适合保存应用中的一些临时文件，用完就删除。
 */
+(NSString *)tmpFolder;



/**
 *  生成子文件夹
 *
 *  如果子文件夹不存在，则直接创建；如果已经存在，则直接返回
 *
 *  @param subFolder 子文件夹名
 *
 *  @return 文件夹路径
 */
-(NSString *)createSubFolder:(NSString *)subFolder;


@end
