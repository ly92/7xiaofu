//
//  ShowaddbillModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Service_Type,Service_Sector12,Service_Sector12,Service_Form,Payment_List1;
@interface ShowaddbillModel : NSObject

@property (nonatomic, strong) NSArray<Service_Form *> *service_form;//【服务形式】

@property (nonatomic, strong) NSArray<Service_Sector12 *> *service_sector;//【服务领域】

@property (nonatomic, copy) NSString *reference;//	参考价格说明（无图片）

@property (nonatomic, strong) NSArray<Payment_List1 *> *payment_list;//【支付方式】

@property (nonatomic, strong) NSArray<Service_Type *> *service_type;//【服务类型】

@property (nonatomic, assign) float top_price;//置顶金额 （天）

@property (nonatomic, assign) float available_predeposit;//可用预存款余额

@end

@interface Service_Type : NSObject

@property (nonatomic, copy) NSString *field_name;//	服务形式名称

@property (nonatomic, copy) NSString *field_value;//	服务形式ID

@end

@interface Service_Sector22 : NSObject

@property (nonatomic, copy) NSString *gc_id;//	分类ID

@property (nonatomic, copy) NSString *gc_name;//	分类名称

@property (nonatomic, copy) NSString *gc_image;

@end

@interface Service_Sector12 : NSObject

@property (nonatomic, copy) NSString *gc_id;//	分类ID

@property (nonatomic, copy) NSString *gc_name;//	分类名称

@property (nonatomic, copy) NSString *gc_image;
@property (nonatomic, strong) NSArray<Service_Sector22 *> *list;//【服务类型】
@end

@interface Service_Form : NSObject

@property (nonatomic, copy) NSString *field_name;//服务类型名称

@property (nonatomic, copy) NSString *field_value;//	服务类型ID

@end

@interface Payment_List1 : NSObject

@property (nonatomic, copy) NSString *payment_name;//	支付名称

@property (nonatomic, copy) NSString *payment_img;//支付图片

@property (nonatomic, copy) NSString *payment_id;//	支付ID

@end

