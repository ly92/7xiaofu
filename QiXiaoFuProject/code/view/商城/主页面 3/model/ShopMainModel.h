//
//  ShopMainModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 fhj. All rights reserved.
//

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

