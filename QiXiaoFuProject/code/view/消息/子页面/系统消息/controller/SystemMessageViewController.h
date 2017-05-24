//
//  SystemMessageViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 fhj. All rights reserved.
//  系统消息页面

#import "BaseViewController.h"

//系统消息类型
typedef NS_ENUM(NSInteger ,SystemMessageType){

    SystemMessageTypeSystem           = 1,
    SystemMessageTypeMoney            = 2,
    SystemMessageTypeSendReceiveMoney = 3
    
};

@interface SystemMessageViewController : BaseViewController

@property(nonatomic, assign)SystemMessageType systemMessageType;

@end
