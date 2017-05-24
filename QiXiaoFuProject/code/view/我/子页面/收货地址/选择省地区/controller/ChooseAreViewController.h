//
//  ChooseAreViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseAreViewController : BaseViewController


@property(nonatomic, copy) void (^chooseAreBlock)(NSString * area_name,NSString * area_id);


@end


@interface AreaModel : NSObject

@property (nonatomic,copy)NSString *  area_name;

@property (nonatomic,copy)NSString *  area_id;

@end
