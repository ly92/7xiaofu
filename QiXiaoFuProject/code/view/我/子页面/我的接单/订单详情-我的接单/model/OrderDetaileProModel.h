//
//  OrderDetaileModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Payment_List23;
@interface OrderDetaileProModel : NSObject

@property (nonatomic, copy) NSString *entry_name;//项目名称

@property (nonatomic, copy) NSString *bill_sn;//订单号

@property (nonatomic, copy) NSString *bill_user_name;//发单人名称

@property (nonatomic, copy) NSString *bill_desc;//备注

@property (nonatomic, copy) NSString *title;//	项目标题

@property (nonatomic, copy) NSString *ot_user_id;//	接单人ID

@property (nonatomic, copy) NSString *available_predeposit;//可用余额

@property (nonatomic, assign) NSInteger bill_statu;//发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】

@property (nonatomic, strong) NSArray <NSString *>*image;//	图片一维数组

@property (nonatomic, copy) NSString *service_price;

@property (nonatomic, copy) NSString *bill_user_avatar;//发单人头像URL

@property (nonatomic, copy) NSString *other_service_sector;//其他服务领域

@property (nonatomic, copy) NSString *service_sector;//	服务领域

@property (nonatomic, copy) NSString *ot_user_name;//接单人名称

@property (nonatomic, copy) NSString *other_service_brand;//其他服务品牌和型号

@property (nonatomic, copy) NSString *bill_user_id;//	发单人ID

@property (nonatomic, copy) NSString *is_top;//是否置顶 0：否 1：是

@property (nonatomic, copy) NSString *number;//数量和单位

@property (nonatomic, copy) NSString *id;//	项目ID

@property (nonatomic, copy) NSString *service_etime;//预约结束时间

@property (nonatomic, copy) NSString *service_brand;//服务品牌和型号

@property (nonatomic, copy) NSString *service_city;//预约城市名称

@property (nonatomic, copy) NSString *inputtime;//创建时间

@property (nonatomic, copy) NSString *service_up_price;//调价价格

@property (nonatomic, copy) NSString *service_form;//服务形式

@property (nonatomic, copy) NSString *ot_user_avatar;//接单人头像URL

@property (nonatomic, copy) NSString *service_address;//	服务区域详细地址

@property (nonatomic, strong) NSArray<Payment_List23 *> *payment_list;

@property (nonatomic, copy) NSString *service_type;//	服务类型

@property (nonatomic, copy) NSString *service_stime;//预约开始时间

@property (nonatomic, strong) NSArray <NSString *>* up_images;//调价图片数组

@property (nonatomic, assign) NSInteger pay_statu;//支付状态【0 未支付】【1 已支付】【2 取消支付】

@property (nonatomic, assign) NSInteger bill_end_time;//发单支付 剩余时间/秒数 【默认1小时过期】

@property (nonatomic, copy) NSString *top_price;//置顶费用

@property (nonatomic, assign) NSInteger os;//用户在线状态【0 离线】【1 在线】

@property (nonatomic, copy) NSString * call_name;//用户注册账号-- 用于调起环信

@property (nonatomic, copy) NSString * call_nik_name;//用户注册昵称-- 用于调起环信

@property (nonatomic, assign) NSInteger t_state;//

@property (nonatomic, assign) NSInteger is_eval;//



@end

@interface Payment_List23 : NSObject

@property (nonatomic, copy) NSString *payment_name;//	支付名称

@property (nonatomic, copy) NSString *payment_img;//	支付图片

@property (nonatomic, copy) NSString *payment_id;//	支付ID

@end









//                top_price = "0",
 //























