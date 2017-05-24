//
//  ChooseSNNumViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseSNNumViewController : BaseViewController

//@property(nonatomic, copy) void (^chooseSNNumBlock)(NSString * sn,NSString * sn_id);

@property(nonatomic, copy)NSString * order_id;// 退换货用到的订单id



@property(nonatomic, strong)NSMutableDictionary * selectDict;

@property(nonatomic, copy) void (^chooseSNNumBlock)(NSMutableDictionary * selectDict);



@end
