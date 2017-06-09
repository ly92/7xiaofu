//
//  EngineerDetaileModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  Service_Sector1,Evaluation1,Service_Brand1,Cer_Images,Reply_List1;
@interface EngineerDetaileModel : NSObject



@property (nonatomic, strong) NSArray<Service_Sector1 *> *service_sector;//技能领域【一维数组】

@property (nonatomic, strong) NSArray<Cer_Images *> *cer_images;//资质证书【一维数组 图片URL】

@property (nonatomic, copy) NSString *working_year;// 从业年限

@property (nonatomic, copy) NSString *is_real;//是否认证 【0 未认证】【1 已认证】【2 认证待审核】

@property (nonatomic, copy) NSString *member_truename;// 工程师名称
@property (nonatomic, copy) NSString *to_user_name;//备注名


@property (nonatomic, strong) NSArray<Evaluation1 *> *evaluation;//评价

@property (nonatomic, copy) NSString *member_id;//工程师ID

@property (nonatomic, copy) NSString *member_avatar;//工程师头像URL

//@property (nonatomic, strong) NSArray<Service_Brand1 *> *service_brand;//擅长品牌【一维数组】
@property (nonatomic, strong) NSString *service_brand;//擅长品牌【一维数组】

@end

@interface Service_Sector1 : NSObject

@property (nonatomic, copy) NSString *gc_name;

@end

@interface Evaluation1 : NSObject

@property (nonatomic, copy) NSString *member_truename;//用户名称

@property (nonatomic, copy) NSString *member_avatar;//用户头像URL

@property (nonatomic, copy) NSString *member_id;//用户ID

@property (nonatomic, assign) float stars;//星级数

@property (nonatomic, copy) NSString *content;//	评论内容

@property (nonatomic, copy) NSString *time;//评论时间 【时间戳】

@property (nonatomic, strong) NSArray<Reply_List1 *> *reply_list;


@end

@interface Service_Brand1 : NSObject

@property (nonatomic, copy) NSString *gc_name;

@end


@interface Cer_Images : NSObject

@property (nonatomic, copy) NSString *cer_image_name;

@property (nonatomic, copy) NSString *cer_image;

@end


@interface Reply_List1 : NSObject

@property (nonatomic, copy) NSString *member_truename;

@property (nonatomic, copy) NSString *member_avatar;

@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *time;

@end


