//
//  ChooseSeviceDomainViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"
#import "ShowaddbillModel.h"



@interface ChooseSeviceDomainViewController : BaseViewController


@property (nonatomic, strong) NSArray* domains;// 区域数据

@property (nonatomic, assign) BOOL allowsMultipleSelection;// 是不是需要多选

@property (nonatomic, strong) NSSet* selectedContactIds;
@property (nonatomic, strong) NSSet* disabledContactIds;


@property(nonatomic, copy) void (^domainsChooseSeviceDomainViewBlock)(NSArray  *somains);



@end
