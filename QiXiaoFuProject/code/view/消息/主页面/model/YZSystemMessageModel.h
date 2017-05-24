//
//  SystemMessageModel.h
//  QiXiaoFuProject
//
//  Created by 付彦彰 on 2017/5/16.
//  Copyright © 2017年 fhj. All rights reserved.
//  系统消息模型 包括系统消息 资金消息 接发单消息

#import <Foundation/Foundation.h>

@class YZUnReadMessageModel;

@interface YZSystemMessageModel : NSObject

@property (nonatomic, strong) NSArray <YZUnReadMessageModel *> *countnum_all_count;
@property (nonatomic, strong) NSString *from_member_name;
@property (nonatomic, strong) NSString *jump_id;
@property (nonatomic, strong) NSString *jump_type;
@property (nonatomic, strong) NSString *message_body;
@property (nonatomic, strong) NSString *message_id;
@property (nonatomic, strong) NSString *message_img;

@property (nonatomic, assign) NSInteger message_new_time;

@property (nonatomic, strong) NSString *message_open;

@property (nonatomic, assign) NSInteger message_time;

@property (nonatomic, strong) NSString *message_title;
@property (nonatomic, strong) NSString *message_type;

@property (nonatomic, assign) NSInteger msg_read_status;

@property (nonatomic, strong) NSString *store_id;


@end

@interface YZUnReadMessageModel : NSObject

@property (nonatomic, strong) NSString *countnum;

@property (nonatomic, strong) NSString *msg_type;

@end
