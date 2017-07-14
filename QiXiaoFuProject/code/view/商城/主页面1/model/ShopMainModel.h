//
//  ShopMainModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 fhj. All rights reserved.
// 商城页面 轮播图数据  左侧二级列表数据gc_id =0   右侧三级列表数据

#import <Foundation/Foundation.h>

@class Banner_List,Class_List;
@interface ShopMainModel : NSObject


@property (nonatomic, strong) NSArray<Banner_List *> *banner_list;

@property (nonatomic, strong) NSArray<Class_List *> *class_list;

@end

@interface Banner_List : NSObject

@property (nonatomic, copy) NSString *banner_image;

@property (nonatomic, assign) NSInteger banner_type;

@property (nonatomic, copy) NSString *banner_gc_id;

@property (nonatomic, copy) NSString *banner_url;

@property (nonatomic, copy) NSString *banner_goods_id;

@end

@interface Class_List : NSObject

@property (nonatomic, copy) NSString *gc_id;

@property (nonatomic, copy) NSString *gc_name;

@property (nonatomic, copy) NSString *gc_image;

@end

