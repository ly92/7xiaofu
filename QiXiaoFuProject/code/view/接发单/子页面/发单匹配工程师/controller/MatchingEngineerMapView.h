//
//  MatchingEngineerMapView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/12/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "EngineerModel.h"


@interface MatchingEngineerMapView : MKAnnotationView

@property (strong, nonatomic)EngineerModel * bdModel;
- (void)loadDataWithModel:(EngineerModel *)model;
@property (nonatomic,retain)UIView *contentView;


@end
