//
//  ReceivingOrderShowModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Gc_List;
@interface ReceivingOrderShowModel : NSObject


@property (nonatomic, copy) NSString *service_stime;

@property (nonatomic, copy) NSString *service_etime;

@property (nonatomic, strong) NSArray *citys;

@property (nonatomic, strong) NSArray<Gc_List *> *gc_list;

@end

@interface Gc_List : NSObject

@property (nonatomic, assign) NSInteger is_select;

@property (nonatomic, copy) NSString *gc_image;

@property (nonatomic, copy) NSString *gc_id;

@property (nonatomic, copy) NSString *gc_name;

@end

