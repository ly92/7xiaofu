//
//  MySendOrderModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/8.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySendOrderModel : NSObject

@property (nonatomic, copy) NSString *id;//发单ID

@property (nonatomic, copy) NSString *entry_name;//项目名称


@property (nonatomic, assign) NSInteger pay_statu;//支付状态【0 未支付】【1 已支付】【2 取消支付】

@property (nonatomic, copy) NSString *is_top;//是否置顶信息 【0 否】【1 是】

@property (nonatomic, copy) NSString *inputtime;//发布时间

@property (nonatomic, copy) NSString *service_etime;//发单结束时间

@property (nonatomic, copy) NSString *service_city;//发单城市名称

@property (nonatomic, copy) NSString *service_stime;//发单开始时间

@property (nonatomic, copy) NSString *title;//发单标题

@property (nonatomic, assign) NSInteger bill_statu;//发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】

@property (nonatomic, copy) NSString *top_last_day;//置顶结束日期【时间戳】

@property (nonatomic, assign) NSInteger bill_end_time;//发单支付 剩余时间/秒数 【默认1小时过期】

@property (nonatomic, copy) NSString *ot_user_id;//接单人用户ID

@property (nonatomic, copy) NSString *service_price;//发单价格

@property (nonatomic, assign) NSInteger os;//用户在线状态【0 离线】【1 在线】

@property (nonatomic, copy) NSString * call_name;//用户注册账号-- 用于调起环信

@property (nonatomic, copy) NSString * call_nik_name;//用户注册昵称-- 用于调起环信

@property (nonatomic, copy) NSString * bill_user_avatar;//用户注册头像-- 用于调起环信

@property (nonatomic, copy) NSString * ot_user_avatar;//用户自己的头像-- 用于调起环信

@property (nonatomic, assign) NSInteger t_state;//工程师完成状态【0 未完成】【1 已完成】

@property (nonatomic, assign) NSInteger is_eval;//是否已评价【0 未评价】【1 已评价】


//转移
@property (nonatomic, copy) NSString *move_to_eng_name;//接收者name
@property (nonatomic, copy) NSString *move_state;//转移状态1在转移  2已接受  0已拒绝
@property (nonatomic, copy) NSString *move_count;//剩余转移次数
@property (nonatomic, copy) NSString *move_to_eng_id;//接受者ID
@property (nonatomic, copy) NSString *bill_belong;//1别人转给我的 2我转移给别人的

@end


//
//                call_nik_name = "",
//                ot_user_id = "0",
//                title = "数据库-现场服务",
//                top_last_day = "0",
//                is_eval = "0",
//                bill_statu = "4",
//                bill_end_time = 0,
//                service_price = "99.00",
//                pay_statu = "1",
//                bill_user_avatar = "http://139.129.213.138/data/upload/shop/common/default_user_portrait.gif",
//                os = "0",
//                service_etime = "1478669100",
//                id = "1126",
//                inputtime = "1478582778",
//                service_city = "山西",
//                is_top = "0",
//                call_name = "",
//                t_state = "0",
//                ot_user_avatar = "http://139.129.213.138/data/upload/shop/common/default_user_portrait.gif",
//                service_stime = "1478582700",




//                参数名	类型	说明
//                id	str	发单ID
//                title	str
//                service_stime	str	发单开始时间
//                service_etime	str	发单结束时间
//                service_city	str	发单城市名称
//                service_price	str	发单价格
//                inputtime	str	发布时间
//                pay_statu	str	支付状态【0 未支付】【1 已支付】【2 取消支付】
//                bill_statu	str	发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】
//                is_top	str
//                top_last_day	str	置顶结束日期【时间戳】
//                bill_end_time	str	发单支付 剩余时间/秒数 【默认1小时过期】
//                ot_user_id	str	接单人用户ID
