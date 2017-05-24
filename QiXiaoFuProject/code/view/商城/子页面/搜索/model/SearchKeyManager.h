//
//  SearchKeyManager.h
//  bzy
//
//  Created by 八爪鱼 on 16/3/23.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchKeyModel.h"
#define kProductSearchKey [NSString stringWithFormat:@"ProductSearchKey_uid%@",kUserId]
#define kProductSearchKeyMaxCount 10
@interface SearchKeyManager : NSObject

+ (instancetype)sharedManager;
/** 搜索结果*/
-(NSMutableArray*)searchProductSearchKey;
/** 插入关键字*/
-(void)insertProductSearchKey:(NSString*)key;
/** 删除关键字*/
-(void)removeProductSearchKey:(NSString*)key;
/** 删除所有关键字*/
-(void)removeProductAllSearchKey;

/** 更新关键字*/
-(void)updateProductSearchKey:(NSString*)key;
@end
