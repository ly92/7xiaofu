//
//  UserInfoModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/8.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Service_Sector234,Service_Brand,Cer_Images234;
@interface UserInfoModel1 : NSObject

@property (nonatomic, copy) NSString *member_avatar;

@property (nonatomic, copy) NSString *working_time;

@property (nonatomic, strong) NSArray<Service_Sector234 *> *service_sector;

//@property (nonatomic, strong) NSArray<Service_Brand *> *service_brand;
@property (nonatomic, copy) NSString * service_brand;


@property (nonatomic, strong) NSArray<Cer_Images234 *> *cer_images;

@property (nonatomic, copy) NSString *member_nik_name;

@property (nonatomic, assign) NSInteger is_paypwd;//是否设置支付密码【0 否】【1 是】

@property (nonatomic, assign) NSInteger is_real;//是否实名认证【0 否 1 是】

@property (nonatomic, copy) NSString * iv_code;// 邀请码

@property (nonatomic, copy) NSString *member_id;//工程师ID

@property (nonatomic, copy) NSString *member_level;// 级别


@end

@interface Service_Sector234 : NSObject

@property (nonatomic, copy) NSString *gc_id;

@property (nonatomic, copy) NSString *gc_name;

@end

@interface Service_Brand : NSObject

@property (nonatomic, copy) NSString *gc_id;

@property (nonatomic, copy) NSString *gc_name;

@end


@interface Cer_Images234 : NSObject

@property (nonatomic, copy) NSString *cer_image;

@property (nonatomic, copy) NSString *cer_image_name;

@property (nonatomic, assign) NSInteger cer_image_type; //证书状态 【10 通过】【20 未通过】【30 待审核】

@property (nonatomic, copy) NSString *cer_id;// 证书id


@end




