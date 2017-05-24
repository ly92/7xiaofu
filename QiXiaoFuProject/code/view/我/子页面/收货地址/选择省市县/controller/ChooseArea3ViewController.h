//
//  ChooseArea3ViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@class AreasModel;


@interface ChooseArea3ViewController : BaseViewController

@property(nonatomic, copy) void (^chooseArea3ViewBlock)(AreasModel * areasModelProvince,AreasModel * areasModelCity,AreasModel * areasModelDis);


@end


@interface AreasModel : NSObject

@property (nonatomic,copy)NSString *  area_name;

@property (nonatomic,copy)NSString *  area_id;

@end
