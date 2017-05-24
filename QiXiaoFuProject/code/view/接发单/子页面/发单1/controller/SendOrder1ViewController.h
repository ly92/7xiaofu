//
//  SendOrder1ViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"
#import "ShowaddbillModel.h"

@interface SendOrder1ViewController : BaseViewController

@property (nonatomic, strong) NSMutableDictionary * requestParams;// 客户发单请求参数

@property (nonatomic, strong) ShowaddbillModel * showaddbillModel;// 客户发单请求配置参数

@end
