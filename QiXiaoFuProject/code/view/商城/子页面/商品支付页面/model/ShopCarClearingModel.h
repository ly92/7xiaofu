//
//  ShopCarClearingModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

/**
 *  购物车结算
 */


#import <Foundation/Foundation.h>

@class Address_Info,Inv_Info,Distribution_Info,Payment_List;
@interface ShopCarClearingModel : NSObject

@property (nonatomic, strong) NSArray<Distribution_Info *> *distribution_info;

@property (nonatomic, assign) NSInteger preferential_price;

@property (nonatomic, copy) NSString *integral;

@property (nonatomic, copy) NSString *cart_show_ids;

@property (nonatomic, assign) NSInteger allow_offpay;

@property (nonatomic, strong) Inv_Info *inv_info;

@property (nonatomic, copy) NSString *offpay_hash;

@property (nonatomic, assign) NSInteger store_free_price;

@property (nonatomic, assign) NSInteger goods_nums;

@property (nonatomic, copy) NSString *vat_hash;

@property (nonatomic, copy) NSString *store_name;

@property (nonatomic, assign) NSInteger actual_price;

@property (nonatomic, strong) Address_Info *address_info;

@property (nonatomic, copy) NSString *goods_total;

@property (nonatomic, copy) NSString *freight;

@property (nonatomic, assign) NSInteger integral_money;

@property (nonatomic, assign) NSInteger coupons;

@property (nonatomic, strong) NSArray<Payment_List *> *payment_list;

@property (nonatomic, copy) NSString *freight_hash;

@property (nonatomic, copy) NSString *offpay_hash_batch;

@property (nonatomic, strong) NSArray<NSString *> *goods_images;

@end

@interface Address_Info : NSObject

@property (nonatomic, copy) NSString *address_id;

@property (nonatomic, copy) NSString *true_name;

@property (nonatomic, copy) NSString *area_info;

@property (nonatomic, copy) NSString *mob_phone;

@property (nonatomic, copy) NSString *address;

@end

@interface Inv_Info : NSObject

@property (nonatomic, copy) NSString *inv_state;

@end

@interface Distribution_Info : NSObject

@property (nonatomic, copy) NSString *distribution_id;

@property (nonatomic, copy) NSString *distribution_info;

@end

@interface Payment_List : NSObject

@property (nonatomic, copy) NSString *is_default;

@property (nonatomic, copy) NSString *payment_img;

@property (nonatomic, copy) NSString *payment_name;

@property (nonatomic, copy) NSString *payment_desc;

@property (nonatomic, copy) NSString *payment_id;

@end

