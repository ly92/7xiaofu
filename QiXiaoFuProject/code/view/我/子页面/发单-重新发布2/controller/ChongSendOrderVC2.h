//
//  ChongSendOrderVC2.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"
#import "ChongSendOrderModel.h"

@interface ChongSendOrderVC2 : BaseViewController
@property (nonatomic, strong) NSMutableDictionary * requestParams;// 客户发单请求参数
@property (nonatomic, strong) ChongSendOrderModel * chongSendOrderModel;// 客户发单请求参数

@end
