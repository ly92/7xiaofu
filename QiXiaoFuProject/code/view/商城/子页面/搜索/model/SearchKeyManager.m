//
//  SearchKeyManager.m
//  bzy
//
//  Created by 八爪鱼 on 16/3/23.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "SearchKeyManager.h"
#import "FileManager.h"
@interface SearchKeyManager ()
@property(nonatomic,strong)NSMutableArray* productSearchKeyArry;
@end

@implementation SearchKeyManager

+ (instancetype)sharedManager {
    static SearchKeyManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        shared_manager.productSearchKeyArry = [[NSMutableArray alloc] init];
        
    });
    return shared_manager;
}


/** 搜索结果*/
-(NSMutableArray*)searchProductSearchKey
{
    [self.productSearchKeyArry removeAllObjects];
    NSArray* searchKeyArry = [NSKeyedUnarchiver unarchiveObjectWithFile:[FileManager filePathWithFileName:kProductSearchKey]];
    [self.productSearchKeyArry addObjectsFromArray:searchKeyArry];
    
    return self.productSearchKeyArry;
}

/** 插入关键字*/
-(void)insertProductSearchKey:(NSString*)key
{
    [self removeSameKey:key];
    
    if (self.productSearchKeyArry.count >= kProductSearchKeyMaxCount) {
        
        [self.productSearchKeyArry removeLastObject];
    }
    
    SearchKeyModel* keyModel = [[SearchKeyModel alloc] init];
    keyModel.searchKey = key;
    keyModel.date = [NSDate date];
    
    [self.productSearchKeyArry insertObject:keyModel atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:self.productSearchKeyArry toFile:[FileManager filePathWithFileName:kProductSearchKey]];
}

/** 删除关键字*/
-(void)removeProductSearchKey:(NSString*)key
{
    [self removeSameKey:key];
}

/** 更新关键字*/
-(void)updateProductSearchKey:(NSString*)key
{

}
/** 删除所有关键字*/
-(void)removeProductAllSearchKey
{
    [self.productSearchKeyArry removeAllObjects];
    [NSKeyedArchiver archiveRootObject:self.productSearchKeyArry toFile:[FileManager filePathWithFileName:kProductSearchKey]];
}


-(NSArray*)sameSearchKey:(NSString*)key
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"searchKey=%@",key];
    NSArray *array = [self.productSearchKeyArry filteredArrayUsingPredicate:predicate];
    return array;
}

-(void)removeSameKey:(NSString*)key
{
    //找有相同关键字的
    NSArray* sameArry = [self sameSearchKey:key];
    
    if (sameArry.count > 0)
    {
        for (SearchKeyModel* keyModel in sameArry) {
            
            [self.productSearchKeyArry removeObject:keyModel];
        }
    }

    [NSKeyedArchiver archiveRootObject:self.productSearchKeyArry toFile:[FileManager filePathWithFileName:kProductSearchKey]];
}
@end
