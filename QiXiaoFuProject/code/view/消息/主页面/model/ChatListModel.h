//
//  ChatListModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/11/9.
//  Copyright © 2016年 fhj. All rights reserved.
//  聊天列表模型

#import <Foundation/Foundation.h>

@interface ChatListModel : NSObject

@property (nonatomic,copy) NSString * user;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * userIcon;


@property (nonatomic,copy) NSString * friendUser;
@property (nonatomic,copy) NSString * friendUsername;
@property (nonatomic,copy) NSString * friendUserIcon;

@end
