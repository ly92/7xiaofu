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
@property (nonatomic, copy) NSString *sourceValue;//积分类别
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *integralall;// 当前时间总积分
@property (nonatomic, copy) NSString *shash;
@property (nonatomic, copy) NSString *sourceid;
@property (nonatomic, copy) NSString *integral;// 单次获取的积分
@property (nonatomic, copy) NSString *sourcetype;//积分类型 1购买产品 2活动 3抽奖 4积分兑换 6签到 7其他
@end

/*
//积分类型 1购买产品 2活动 3抽奖 4积分兑换 6签到 7其他 8 9
        switch ([credits.sourcetype intValue]) {
            case 1:{
                //
               cell.nameLbl.text = @"购买产品";
            }
                break;
            case 2:{
                //
                cell.nameLbl.text = @"活动";
            }
                break;
            case 3:{
                //
                cell.nameLbl.text = @"抽奖";
            }
                break;
            case 4:{
                //
                cell.nameLbl.text = @"积分兑换";
            }
                break;
            case 6:{
                //
                cell.nameLbl.text = @"签到";
            }
                break;
            case 7:{
                //
                cell.nameLbl.text = @"新用户注册";
            }
                break;
            case 8:{
                //
                cell.nameLbl.text = @"实名认证";
            }
                break;
            case 9:{
                //
                cell.nameLbl.text = @"推荐好友";
            }
                break;
            case 10:{
                //
                cell.nameLbl.text = @"第一次完成订单";
            }
                break;

            default:{
                //
                cell.nameLbl.text = @"其他";
            }
                break;
        }
*/
