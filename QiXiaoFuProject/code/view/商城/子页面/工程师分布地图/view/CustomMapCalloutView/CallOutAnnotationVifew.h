//
//  CallOutAnnotationVifew.h
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "EngineerDistributedModel.h"
#import <MAMapKit/MAMapKit.h>

@protocol CallOutAnnotationVifewDelegate <NSObject>

- (void)toNavigationMapwithModel:(EngineerDistributedModel *)mod;

@end


@interface CallOutAnnotationVifew : MAAnnotationView
@property (strong, nonatomic)EngineerDistributedModel * bdModel;
- (void)loadDataWithModel:(EngineerDistributedModel *)model;
@property (nonatomic,retain)UIView *contentView;


@property (assign, nonatomic)id<CallOutAnnotationVifewDelegate>delegate;


@end
