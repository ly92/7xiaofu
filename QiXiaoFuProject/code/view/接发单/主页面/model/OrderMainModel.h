//
//  OrderMainModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/8.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bill_List,Class_List12,Class_List22,Member_list;
@interface OrderMainModel : NSObject

@property (nonatomic, strong) NSArray<Bill_List *> *bill_list;

@property (nonatomic, strong) NSArray<NSString *> *banner_list;

@property (nonatomic, strong) NSArray<NSString *> *eng_banner_list;

@property (nonatomic, strong) NSArray<Class_List12 *> *class_list;

@property (nonatomic, strong) NSArray<Member_list *> *member_list;


@end

@interface Bill_List : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *id;

@end

@interface Class_List22 : NSObject

@property (nonatomic, copy) NSString *gc_id;

@property (nonatomic, copy) NSString *gc_name;

@property (nonatomic, copy) NSString *gc_image;

@end

@interface Class_List12 : NSObject

@property (nonatomic, copy) NSString *gc_id;

@property (nonatomic, copy) NSString *gc_name;

@property (nonatomic, copy) NSString *gc_image;

@property (nonatomic, strong) NSArray<Class_List22 *> *list;

@end



@interface Member_list : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *id;

@end
