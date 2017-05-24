//
//  EngineerHeaderReusableView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBannerView.h"
#import "CLHomeHeader.h"

@interface EngineerHeaderReusableView : UICollectionReusableView<MCBannerViewDataSource, MCBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *adView;

@property (nonatomic, strong) MCBannerView *banner;
@property (nonatomic, strong) NSArray *bannerArray;

@property (nonatomic, strong) CLHomeHeader * cLHomeHeader;
@property (nonatomic, strong) NSArray *adArray;

@property(nonatomic,copy)void (^clickEngineerHeaderReusableViewBlock)(NSString * t_id);

@property(nonatomic,copy)void (^clickEngineerHeaderReusableViewMoreBtnBlock)(NSString * t_id);




@end
