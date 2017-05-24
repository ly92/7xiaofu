//
//  MyStockChangeZreaViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 fhj. All rights reserved.
//


#import "BaseViewController.h"

@class MAreasModel;


@interface MyStockChangeZreaViewController : BaseViewController

@property(nonatomic, copy) void (^myStockChangeZreaVCBlock)(MAreasModel * areasModelProvince,MAreasModel * areasModelCity,MAreasModel * areasModelDis);


@end


@interface MAreasModel : NSObject

@property (nonatomic,copy)NSString *  area_name;

@property (nonatomic,copy)NSString *  area_id;

@end
