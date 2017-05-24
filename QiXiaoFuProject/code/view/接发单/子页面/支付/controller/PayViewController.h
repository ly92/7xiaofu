//
//  PayViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"
#import "ShowaddbillModel.h"

@interface PayViewController : BaseViewController
@property (nonatomic, strong) NSMutableDictionary * requestParams;// 客户发单请求参数
@property (nonatomic, assign) BOOL isTop;// 有没有置顶

@property (nonatomic, strong) ShowaddbillModel * showaddbillModel;// 客户发单请求配置参数


@property (nonatomic, assign) BOOL isBuDan;// 是否是补单


@end
