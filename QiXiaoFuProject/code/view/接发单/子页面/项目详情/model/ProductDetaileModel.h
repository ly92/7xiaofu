//
//  ProductDetaileModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductDetaileModel : NSObject


@property (nonatomic, copy) NSString *bill_user_name;//发单人名称

@property (nonatomic, copy) NSString *bill_desc;//备注

@property (nonatomic, copy) NSString *title;//	项目标题

@property (nonatomic, strong) NSArray<NSString *> *image;//图片一维数组

@property (nonatomic, assign) NSInteger bill_statu;//发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】

@property (nonatomic, copy) NSString *service_price;//	价格

//@property (nonatomic, copy) NSString *service_mod;//其他服务型号

@property (nonatomic, copy) NSString *bill_user_avatar;//	发单人头像URL

@property (nonatomic, copy) NSString *other_service_sector;//其他服务领域

@property (nonatomic, copy) NSString *service_sector;//服务领域

@property (nonatomic, copy) NSString *other_service_brand;//	其他服务品牌

@property (nonatomic, copy) NSString *other_service_mod;//其他服务型号

@property (nonatomic, copy) NSString *is_top;//	是否置顶 0：否 1：是

@property (nonatomic, copy) NSString *number;//	数量

@property (nonatomic, copy) NSString *id;//	项目ID

@property (nonatomic, copy) NSString *service_etime;//	预约结束时间

@property (nonatomic, copy) NSString *service_brand;//	服务品牌

@property (nonatomic, copy) NSString *service_city;//	预约城市名称

@property (nonatomic, copy) NSString *inputtime;//	创建时间

@property (nonatomic, copy) NSString *bill_user_id;//	发单人ID

@property (nonatomic, assign) NSInteger button_type;//接单按钮是否可点击 0：不可点击【购买自己发布的产品，账号已被封】 1：可点击【未登录，登陆已失效】

@property (nonatomic, copy) NSString *service_form;//	服务形式

@property (nonatomic, copy) NSString *service_address;//	服务区域详细地址

@property (nonatomic, copy) NSString *service_type;//服务类型

@property (nonatomic, copy) NSString *service_stime;//	预约开始时间
@property (nonatomic, copy) NSString *entry_name;//项目名称

@end


//                参数名	类型	说明
//                service_sector	str	服务领域
//                service_brand	str	服务品牌
//                service_mod	str	服务型号
//                other_service_sector	str	其他服务领域
//                other_service_brand	str	其他服务品牌
//                other_service_mod	str	其他服务型号
//                service_form	str	服务形式
//                service_type	str	服务类型
//                bill_statu	str	发单状态 0：撤销 1：待结单 2：已接单 3：已完成 4：已过期
//                service_address	str	服务区域详细地址
//                bill_desc	str	备注
//                number	str	数量
//                is_top	str	是否置顶 0：否 1：是
//                id	str	项目ID
//                title	str	项目标题
//                service_stime	str	预约开始时间
//                service_etime	str	预约结束时间
//                service_city	str	预约城市名称
//                service_price	str	价格
//                inputtime	str	创建时间
//                image	array	图片一维数组
//                bill_user_id	str	发单人ID
//                bill_user_name	str	发单人名称
//                bill_user_avatar	str	发单人头像URL
//                button_type	int	接单按钮是否可点击 0：不可点击【购买自己发布的产品，账号已被封】 1：可点击【未登录，登陆已失效】





