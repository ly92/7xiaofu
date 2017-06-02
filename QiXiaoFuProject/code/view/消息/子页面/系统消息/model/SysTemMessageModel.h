//
//  SysTemMessageModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/ 26.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysTemMessageModel : NSObject

@property (copy,nonatomic)NSString * message_id;
@property (copy,nonatomic)NSString * message_body;
@property (copy,nonatomic)NSString * message_time;
@property (copy,nonatomic)NSString * from_member_name;
@property (copy,nonatomic)NSString * message_img;
@property (assign,nonatomic)NSInteger  message_open;
@property (copy,nonatomic)NSString * jump_id;
@property (assign,nonatomic)NSInteger  jump_type;
@property (copy,nonatomic)NSString * move_state;
@end


//            "message_id":"15",
//            "message_body":"这是最新的一条小",
//            "message_time":"1455870453",
//            "from_member_name":"系统消息",
//            "link":"",
//            "goods_id":"",
//            "store_id" : "1",
//            "activity_id":"",
//            "type" : "1",
//            "message_open" : "1"
//            "message_img":"http://139.129.213.138/data/upload/shop/avatar/avatar_2.jpg"



//            参数名	类型	说明
//            message_id	string	消息ID
//            message_body	string	消息内容
//            message_time	string	消息时间
//            from_member_name	string	消息标题
//            message_img	string	消息图片
//            message_open	string	1，已读 0，未读
//            jump_id	string	跳转ID
//            jump_type	string	【71：项目详情】【72：接单详情】【73：发单详情】【74：跳转到钱包详情里，此时jump_id为空】【75：众筹详情】
