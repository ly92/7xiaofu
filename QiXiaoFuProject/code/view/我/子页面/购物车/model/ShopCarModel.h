//
//  ShopCarModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cart_List;
@interface ShopCarModel : NSObject


@property (nonatomic, copy) NSString *sum;

@property (nonatomic, strong) NSArray<Cart_List *> *cart_list;

@property (nonatomic, assign) NSInteger count;

@end

@interface Cart_List : NSObject

@property (nonatomic, assign) NSInteger goods_num;

@property (nonatomic, copy) NSString *goods_image;

@property (nonatomic, copy) NSString *goods_image_url;

@property (nonatomic, copy) NSString *goods_price;

@property (nonatomic, copy) NSString *cart_id;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *goods_sum;

@property (nonatomic, copy) NSString *goods_id;

@property(assign,nonatomic) BOOL selectState;//是否选中状态

@property (nonatomic, copy) NSString *sum;
@end

//            参数名	类型	说明
//            cart_id	string	购物车ID
//            goods_id	string	商品ID
//            goods_name	string	商品名称
//            goods_price	string	商品价格
//            goods_num	string	购买商品数量
//            goods_image_url	string	商品图片
//            goods_sum	string	该商品的总价
//            count	string	商品总数

//            sum（购物车总价）参数说明：
//            参数名	类型	说明
//            sum	string	购物车总价
