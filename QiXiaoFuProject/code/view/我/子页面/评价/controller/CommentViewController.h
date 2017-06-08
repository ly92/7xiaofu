//
//  CommentViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentViewController : BaseViewController

@property (nonatomic,copy)NSString * f_id;
@property (nonatomic, assign) BOOL isFromEng;//工程师对客户评价


@property(nonatomic, copy) void (^commentViewBlock)();




@end
