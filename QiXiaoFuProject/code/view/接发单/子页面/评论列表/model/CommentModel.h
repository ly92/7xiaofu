//
//  CommentModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reply_List;
@interface CommentModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *member_truename;

@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, copy) NSString *member_avatar;

@property (nonatomic, copy) NSString *stars;

@property (nonatomic, copy) NSString *eval_id;

@property (nonatomic, strong) NSArray<Reply_List *> *reply_list;

@end

@interface Reply_List : NSObject

@property (nonatomic, copy) NSString *member_truename;

@property (nonatomic, copy) NSString *member_avatar;

@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *time;

@end

