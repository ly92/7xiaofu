//
//  ChatDBManager.h
//  QiXiaoFuProject
//
//  Created by mac on 16/11/9.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatListModel.h"


@interface ChatDBManager : NSObject

//通过此类方法，得到单例
+(ChatDBManager *)shareManager;
//将数据模型中的数据插入到表中
- (void)insertDataWithModel:(ChatListModel *)model;

//根据主键id删除某条数据( 删除 一个朋友 )
- (void)deleteDataWithUserId:(ChatListModel *)model;

//获取所有的数据
- (ChatListModel *)fetchAllUserWithFriendUser:(NSString *)friendUser;

@end
