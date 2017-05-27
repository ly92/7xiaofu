//
//  CommentListViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentListViewController : BaseViewController
@property (nonatomic, strong) NSString  *member_id;
@property (nonatomic, assign) NSInteger type;// 1 从个人信息进去（不可评论）

@property (nonatomic, assign) BOOL isCustomer;//是否为客户


@end
