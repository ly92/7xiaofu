//
//  ShopPositionModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Listdata,Shop_List,Eng_List;
@interface ShopPositionModel : NSObject

@property (nonatomic, strong) NSArray<Eng_List *> *eng_list;

@property (nonatomic, strong) NSArray<Shop_List *>*shop_list;

@end

@interface Shop_List : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *count;

@end

@interface Eng_List : NSObject

@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *area_id;

@end

