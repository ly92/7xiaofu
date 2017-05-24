//
//  RecommendEngineerModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendEngineerModel : NSObject

@property (nonatomic, assign) NSInteger is_top;//是否为置顶信息 0 否 1 是

@property (nonatomic, copy) NSString *service_city;//发单城市名称

@property (nonatomic, copy) NSString *id;//发单ID

@property (nonatomic, copy) NSString *title;//发单标题

@property (nonatomic, copy) NSString *service_stime;//	发单开始时间

@property (nonatomic, copy) NSString *inputtime;//发布时间

@property (nonatomic, copy) NSString *bill_user_name;//发单人名称

@property (nonatomic, copy) NSString *bill_user_avatar;//发单人头像URL

@property (nonatomic, copy) NSString *service_etime;//发单结束时间

@property (nonatomic, copy) NSString *service_price;//发单价格

@property (nonatomic, copy) NSString *bill_user_id;//发单人ID

@end



//                参数名	类型	说明
//                is_top	str	是否为置顶信息 0 否 1 是
//                id	str	发单ID
//                title	str	发单标题
//                service_stime	str	发单开始时间
//                service_etime	str	发单结束时间
//                service_city	str	发单城市名称
//                service_price	str	发单价格
//                inputtime	str	发布时间
//                bill_user_id	str	发单人ID
//                bill_user_name	str	发单人名称
//                bill_user_avatar	str	发单人头像URL
