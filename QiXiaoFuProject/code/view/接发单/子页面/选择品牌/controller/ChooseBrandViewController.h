//
//  ChooseBrandViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseBrandViewController : BaseViewController

@property(nonatomic, copy) NSString *  service_brand;

@property(nonatomic, copy) void (^ chooseBrandViewBlock)(NSString *  text);


@end
