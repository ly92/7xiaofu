//
//  MCBannerView.h
//  BeautifulFaceProject
//
//  Created by 冯 on 16/4/7.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBannerFooter.h"

@protocol MCBannerViewDataSource, MCBannerViewDelegate;

@interface MCBannerView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
 

/** 是否需要循环滚动, 默认为 NO */
@property (nonatomic, assign) IBInspectable BOOL shouldLoop;

/** 是否显示footer, 默认为 NO (此属性为YES时, shouldLoop会被置为NO) */
@property (nonatomic, assign) IBInspectable BOOL showFooter;

/** 是否自动滑动, 默认为 NO */
@property (nonatomic, assign) IBInspectable BOOL autoScroll;

/** 自动滑动间隔时间(s), 默认为 3.0 */
@property (nonatomic, assign) IBInspectable NSTimeInterval scrollInterval;

/** pageControl, 可自由配置其属性 */
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@property (nonatomic, weak) IBOutlet id<MCBannerViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<MCBannerViewDelegate> delegate;

- (void)reloadData;

- (void)startTimer;
- (void)stopTimer;

@end

@protocol MCBannerViewDataSource <NSObject>
@required

- (NSInteger)numberOfItemsInBanner:(MCBannerView *)banner;
- (UIView *)banner:(MCBannerView *)banner viewForItemAtIndex:(NSInteger)index;

@optional

- (NSString *)banner:(MCBannerView *)banner titleForFooterWithState:(MCBannerFooterState)footerState;

@end

@protocol MCBannerViewDelegate <NSObject>
@optional

- (void)banner:(MCBannerView *)banner didSelectItemAtIndex:(NSInteger)index;
- (void)bannerFooterDidTrigger:(MCBannerView *)banner;

@end






