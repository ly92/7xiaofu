//
//  CollectGoodModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectGoodModel : NSObject

@property (nonatomic,copy)NSString *goods_id;
@property (nonatomic,copy)NSString *goods_name;
@property (nonatomic,copy)NSString *goods_image;
@property (nonatomic,copy)NSString *goods_price;
@property (nonatomic,copy)NSString *goods_marketprice;
@property (nonatomic,copy)NSString *goods_salenum;
@property (nonatomic,copy)NSString *goods_storage;
@property (nonatomic,copy)NSString *fav_id;
@property (nonatomic,copy)NSString *goods_image_url;

@end



//            "goods_id":"100020",
//            "goods_name":"婴幼儿品质奶粉",
//            "goods_image":"http://139.129.213.138/data/upload/shop/store/goods/1/1_05074673040032345_360.jpg",
//            "goods_price":"22.00",
//            "goods_marketprice":"33.00",
//            "goods_salenum":"1",
//            "goods_storage":"21",
//            "fav_id":"100020"

//
//            参数名	类型	说明
//            goods_id	string	商品ID
//            goods_name	string	商品名称
//            goods_image	string	商品图片
//            goods_price	string	商品价格
//            goods_marketprice	string	商品价格
//            goods_salenum	string	商品销量
//            goods_storage	string	商品库存
//            fav_id	string	收藏ID
