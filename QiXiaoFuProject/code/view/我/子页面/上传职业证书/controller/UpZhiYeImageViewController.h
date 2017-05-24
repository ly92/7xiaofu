//
//  UpZhiYeImageViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface UpZhiYeImageViewController : BaseViewController

@property (nonatomic, assign) NSInteger depth;


@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, copy) NSString * zhengshuname;
@property (nonatomic, copy) NSString * cer_id;


@property(nonatomic, copy) void (^upZhiYeImageViewControllerBlock)();



@end
