//
//  CustomersHeaderReusableView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CustomersHeaderReusableView.h"
#import "YWWebScrollView.h"

@implementation CustomersHeaderReusableView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self banner];
    [self cLHomeHeader];
    // Initialization code
}



- (MCBannerView *)banner{
    if (!_banner) {
        _banner = [[MCBannerView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,160)];
        _banner.dataSource = self;
        _banner.delegate = self;
        [self.bannerView addSubview:_banner];
        _banner.shouldLoop = YES;
        _banner.showFooter = NO;
        _banner.autoScroll = YES;
    }
    return _banner;
}
- (CLHomeHeader *)cLHomeHeader{
    if (!_cLHomeHeader) {
        _cLHomeHeader = [[CLHomeHeader alloc] initWithFrame:CGRectMake(0, 100, kScreenHeight, 60)];
//        _cLHomeHeader.newses = @[@[@"第0组第一行",@"第0组第二行"],@[@"第一组第一行",@"第一组第二行"],@[@"第二组第一行",@"第二组第一行"],@[@"第3组第一行",@"第3组第二行"]];
//        
        WEAKSELF
        _cLHomeHeader.clickCellMoreBtnBlock = ^(NSString * t_id ){
            
            if (weakSelf.clickEngineerHeaderReusableViewMoreBtnBlock) {
                weakSelf.clickEngineerHeaderReusableViewMoreBtnBlock(t_id);
            }
        };
        _cLHomeHeader.clickCellBlock = ^(NSString * t_id ){
            if (weakSelf.clickEngineerHeaderReusableViewMoreBtnBlock) {
                weakSelf.clickEngineerHeaderReusableViewMoreBtnBlock(t_id);
            }
        };

        
        _cLHomeHeader.frame= CGRectMake(0,0, kScreenWidth, _adView.height);
        [self.adView addSubview:_cLHomeHeader];
    }
    return _cLHomeHeader;
}
- (void)setAdArray:(NSArray *)adArray{
    
    _cLHomeHeader.newses = adArray;
    
}



- (void)setBannerArray:(NSArray *)bannerArray{
    
    _bannerArray = bannerArray;
    
    [_banner reloadData];
    
    
}
#pragma mark - ZYBannerViewDataSource
// 返回Banner需要显示Item(View)的个数
- (NSInteger)numberOfItemsInBanner:(MCBannerView *)banner
{
    return _bannerArray.count;
}

// 返回Banner在不同的index所要显示的View (可以是完全自定义的view, 且无需设置frame)
- (UIView *)banner:(MCBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    // 取出数据
    NSString * imageurl = _bannerArray[index];
    // 创建将要显示控件
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithUrl:imageurl placeholder:kDefaultImage_c1];
    imageView.tag = 100;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

#pragma mark - ZYBannerViewDelegate

// 在这里实现点击事件的处理
- (void)banner:(MCBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
    DeLog(@"点击了第%ld个项目", (long)index);
    YWWebScrollView *scrollView=[[YWWebScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrollView. ScrollViewTag=index;
    scrollView.imageUrls =[NSMutableArray arrayWithArray:_bannerArray];
    scrollView.alpha=0.2;
    [UIView animateWithDuration:0.2f animations:^{
        scrollView.alpha = 1.0f;
    }];

}




@end
