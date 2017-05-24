//
//  UserInfoModel.h
//  PrettyFactoryProject
//
//  Created by mac on 16/6/9.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

 @interface UserInfoModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *pushState;// 是否要接收推送消息

@property (nonatomic, assign) NSInteger is_real;//是否实名认证【0 否 1 是】

@property (nonatomic, assign) NSInteger unreadSystemMessageNumber;//未读的自己系统的消息数量


@end

//        username = "13371762813",
//        tags = 	(
//        ),
//        userid = "5b3035fdd4f8b21235e25afc9ff80e74",
//        store_id = "1",
//        store_name = "宝力优佳",
