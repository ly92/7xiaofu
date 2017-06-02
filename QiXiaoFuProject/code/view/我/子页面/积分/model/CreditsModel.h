//
//  CreditsModel.h
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/6/2.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CreditsObj;

@interface CreditsModel : NSObject
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *all_integral;//总积分

@end

@interface CreditsObj : NSObject
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *addtime;//添加时间
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *integralall;// 当前时间总积分
@property (nonatomic, copy) NSString *shash;
@property (nonatomic, copy) NSString *sourceid;
@property (nonatomic, copy) NSString *integral;// 单次获取的积分
@property (nonatomic, copy) NSString *sourcetype;//积分类型 1购买产品 2活动 3抽奖 4积分兑换 6签到 7其他
@end
