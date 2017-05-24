//
//  ShopListModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goods_List,Area_List,Searching_Type,Value;
@interface ShopListModel : NSObject



@property (nonatomic, strong) NSArray<Goods_List *> *goods_list;

@property (nonatomic, strong) NSArray<Area_List *> *area_list;

@property (nonatomic, strong) NSArray<Searching_Type *> *searching_type;

@end

@interface Goods_List : NSObject

@property (nonatomic, copy) NSString *is_presell;

@property (nonatomic, copy) NSString *is_fcode;

@property (nonatomic, assign) BOOL group_flag;

@property (nonatomic, copy) NSString *goods_marketprice;

@property (nonatomic, copy) NSString *goods_image;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *goods_salenum;

@property (nonatomic, copy) NSString *evaluation_good_star;

@property (nonatomic, copy) NSString *evaluation_count;

@property (nonatomic, copy) NSString *goods_image_url;

@property (nonatomic, assign) BOOL xianshi_flag;

@property (nonatomic, copy) NSString *area_name;

@property (nonatomic, copy) NSString *goods_price;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *goods_img_laber;

@property (nonatomic, copy) NSString *goods_storage;

@property (nonatomic, copy) NSString *areaid_1;

@property (nonatomic, copy) NSString *area_id;

@property (nonatomic, copy) NSString *have_gift;

@property (nonatomic, copy) NSString *is_virtual;

@end

@interface Area_List : NSObject

@property (nonatomic, copy) NSString *area_id;

@property (nonatomic, copy) NSString *area_name;

@end

@interface Searching_Type : NSObject

@property (nonatomic, strong) NSArray<Value *> *value;

@property (nonatomic, copy) NSString *attr_name;

@end

@interface Value : NSObject

@property (nonatomic, copy) NSString *attr_value_id;

@property (nonatomic, copy) NSString *attr_value_name;

@end

