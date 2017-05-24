//
//  ChatDBManager.m
//  QiXiaoFuProject
//
//  Created by mac on 16/11/9.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChatDBManager.h"
#import "FMDatabase.h"


@implementation ChatDBManager{
    FMDatabase *_dataBase;
    FMDatabase * db;
}

static ChatDBManager *manager = nil;
+(ChatDBManager *)shareManager{
    if (manager == nil) {
        manager = [[ChatDBManager alloc] init];
    }
    return manager;
}
//重写init方法，完成必要的初始化操作

- (id)init{
    self = [super init];
    if (self) {
        NSString *dbPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Chatlist.db"];
        _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
        BOOL isSuccessed = [_dataBase open];
        if (isSuccessed) {
            NSString *createSql = @"create table if not exists userInfo(id integer primary key autoincrement,user varchar(256),userName varchar(256),userIcon varchar(256),friendUser varchar(256),friendUsername varchar(256),friendUserIcon varchar(256))";
           BOOL isCreateSuccessed =[_dataBase executeUpdate:createSql];
            if (!isCreateSuccessed) {
                NSLog(@"create error:%@",_dataBase.lastErrorMessage);
            }
        }
    }
    return self;
}




//将数据模型中的数据插入到表中
- (void)insertDataWithModel:(ChatListModel *)model{
    
    FMResultSet *rs = [_dataBase executeQuery:@"select * from userInfo where friendUser = ?",model.friendUser];
    if([rs next])
    {
        NSString *updateSql = @"update userInfo set user=?,userName=?,userIcon =?,friendUser= ?, friendUsername=?,friendUserIcon=? where friendUser = ?";
        BOOL isSuccessd  =[_dataBase executeUpdate:updateSql,model.user,model.userName,model.userIcon,model.friendUser,model.friendUsername,model.friendUserIcon,model.friendUser];
        
        if (isSuccessd == NO) {
            DeLog(@"updateError:%@",_dataBase.lastErrorMessage);
        }
        
    }
    else{
        NSString *insertSql = @"insert into userInfo(user,userName,userIcon,friendUser,friendUsername,friendUserIcon) values(?,?,?,?,?,?)";
        BOOL isSuccessed = [_dataBase executeUpdate:insertSql,model.user,model.userName,model.userIcon,model.friendUser,model.friendUsername,model.friendUserIcon];
        if (isSuccessed == NO) {
            DeLog(@"insert error:%@",_dataBase.lastErrorMessage);
        }
    }
    
}



//根据主键id删除某条数据( 删除 一个朋友 )
- (void)deleteDataWithUserId:(ChatListModel *)model{
   NSString *deleteSql = @"delete from userInfo where friendUser =?";
    
    BOOL isSuccessed = [_dataBase executeUpdate:deleteSql,model.friendUser ];
    if (isSuccessed == NO) {
        NSLog(@"delete error:%@",_dataBase.lastErrorMessage);
    }
}



- (ChatListModel *)fetchAllUserWithFriendUser:(NSString *)friendUser{

  NSString * selectSql = @"select * from userInfo where friendUser = ?";

  FMResultSet *set =[_dataBase executeQuery:selectSql,friendUser];
     while ([set next]) {
         NSString *user=[set stringForColumn:@"user"];
        NSString *userName = [set stringForColumn:@"userName"];
        NSString *userIcon =[set stringForColumn:@"userIcon"];
        NSString *friendUser = [set stringForColumn:@"friendUser"];
        NSString *friendUsername = [set stringForColumn:@"friendUsername"];
        NSString *friendUserIcon = [set stringForColumn:@"friendUserIcon"];
        
        ChatListModel *model = [[ChatListModel alloc] init];
        model.user = user;
        model.userName = userName;
        model.userIcon = userIcon;
        model.friendUser = friendUser;
        model.friendUsername = friendUsername;
        model.friendUserIcon = friendUserIcon;
        return model;
      
    }
    return nil;
}






@end
