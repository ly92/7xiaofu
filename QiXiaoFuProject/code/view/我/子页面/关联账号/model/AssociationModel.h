//
//  AssociationModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User_To_Me,Me_To_User;
@interface AssociationModel : NSObject

@property (nonatomic, strong) NSArray<Me_To_User *> *me_to_user;

@property (nonatomic, strong) User_To_Me *user_to_me;

@end

@interface User_To_Me : NSObject

@property (nonatomic, copy) NSString *member_avatar;

@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, copy) NSString *inputtime;

@property (nonatomic, copy) NSString *to_user_name;

@property (nonatomic, copy) NSString *member_name;

@property (nonatomic, copy) NSString *jibie;


@end

@interface Me_To_User : NSObject

@property (nonatomic, copy) NSString *member_avatar;

@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, copy) NSString *inputtime;

@property (nonatomic, copy) NSString *to_user_name;

@property (nonatomic, copy) NSString *member_name;

@property (nonatomic, copy) NSString *jibie;


@end

