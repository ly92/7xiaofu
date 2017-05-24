//
//  EngineerTureOrderFinishViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"
#import "ShowaddbillModel.h"

@interface EngineerTureOrderFinishViewController : BaseViewController

@property (nonatomic, assign) NSInteger  type;// 1 工程师完成接单 2 补单

@property (nonatomic, copy) NSString * f_id;// 	发单ID

@property(nonatomic, copy) void (^engineerTureOrderFinishViewBlock)();


@end
