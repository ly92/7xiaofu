//
//  ReceivingOrderViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/28.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"
#import "SpaceTimeModel.h"


@interface ReceivingOrderViewController : BaseViewController
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) SpaceTimeModel * spaceTimeModel;

@end
