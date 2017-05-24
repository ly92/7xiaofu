//
//  CommentReplyViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentReplyViewController : BaseViewController
@property (nonatomic, strong) NSString  *parent_id;


@property(nonatomic, copy) void (^ commentReplyViewBlock)();


@end
