//
//  ChooseMapViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface ChooseMapViewController : BaseViewController

@property(nonatomic, copy) void (^chooseSeviceAreaBlock)(AMapTip  *selectPoi);


@end
