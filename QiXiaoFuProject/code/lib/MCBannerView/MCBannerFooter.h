//
//  MCBannerFooter.h
//  BeautifulFaceProject
//
//  Created by 冯 on 16/4/7.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MCBannerFooterState) {
    MCBannerFooterStateIdle = 0,    // 正常状态下的footer提示
    MCBannerFooterStateTrigger,     // 被拖至触发点的footer提示
};

@interface MCBannerFooter : UICollectionReusableView

@property (nonatomic, assign) MCBannerFooterState state;

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, copy) NSString *idleTitle;
@property (nonatomic, copy) NSString *triggerTitle;

@end
