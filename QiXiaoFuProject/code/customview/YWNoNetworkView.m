//
//  YWNoNetworkView.m
//  YiWangClient
//
//  Created by DarkAngel on 14-3-31.
//  Copyright (c) 2014年 一网全城. All rights reserved.
//

#import "YWNoNetworkView.h"
//#import "UIButton+CreateButton.h"
#import <QuartzCore/QuartzCore.h>

@interface YWNoNetworkView ()
/**
 *  重新加载按钮
 */
@property (nonatomic, strong) UIButton *reloadButton;
/**
 *  重新加载的处理
 */
@property (nonatomic, copy) ReloadBlock reloadBlock;
/**
 *  全屏显示与否
 */
@property (nonatomic, assign) BOOL showsInFullScreen;   //default is NO

@end

@implementation YWNoNetworkView

/**
 *  显示数据加载失败
 *
 *  @param view   需要显示的view
 *  @param reload 重新加载数据的处理
 */
+ (void)showNoNetworkInView:(UIView *)view reloadBlock:(ReloadBlock)reload
{
    YWNoNetworkView *noNetworkView = [YWNoNetworkView sharedInstance];
    [view addSubview:noNetworkView];
    noNetworkView.frame = view.bounds;
    noNetworkView.showsInFullScreen = NO;
    [view bringSubviewToFront:noNetworkView];
    [noNetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    [noNetworkView setNeedsDisplay];
    CGFloat top = (view.frame.size.height - 64 - 250)/2.f;
    [noNetworkView.reloadButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(195 + top));
    }];
    if (noNetworkView.reloadBlock) {
        noNetworkView.reloadBlock = NULL;
    }
    noNetworkView.reloadBlock = reload;
}

/**
 *  设置全屏显示
 */
+ (void)setShowsInFullScreen
{
    YWNoNetworkView *noNetworkView = [YWNoNetworkView sharedInstance];
    noNetworkView.showsInFullScreen = YES;
    [noNetworkView setNeedsDisplay];
    CGFloat top = (noNetworkView.superview.frame.size.height - 250)/2.f;
    [noNetworkView.reloadButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(195 + top));
    }];
}


#pragma mark - private methods

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (instancetype)sharedInstance
{
        static YWNoNetworkView *noNetworkView = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            noNetworkView = [[YWNoNetworkView alloc] init];
        });
        return noNetworkView;
}

/**
 *  构造方法
 *
 *  @return 无网络视图对象
 */
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reloadButton.frame = CGRectMake(0, 215, 131, 35);
        self.reloadButton.layer.borderWidth = 1;
        self.reloadButton.layer.borderColor = UIColorFromRGB(0xa1a1a1).CGColor;
        self.reloadButton.layer.cornerRadius = 3;
        [self.reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [self.reloadButton setTitleColor:UIColorFromRGB(0xa1a1a1) forState:UIControlStateNormal];
        self.reloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.reloadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.reloadButton];
        CGFloat top = (self.frame.size.height - (self.showsInFullScreen ? 0 : 64) - 250)/2.f;
        [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(@(195 + top));
            make.size.mas_equalTo(CGSizeMake(131, 35));
        }];
    }
    return self;
}

/**
 *  重新加载数据
 */
- (void)reload
{
    //如果网络不可用，那么直接返回
    //    if ([[YWDataAdapter shareInstance] checkNetworkStatus] == NO) {
    //        //模拟正在加载
    //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    //        [hud setDetailsLabelText:@"正在加载中..."];
    //        [hud setDetailsLabelFont:YIWANG_FONT(16)];
    //        [hud hide:YES afterDelay:1];
    //        return;
    //    }
    
    [self removeTheView];
}
/*!
 *	@brief	手动移除视图
 *
 *	@return	void
 */
- (void)removeTheView
{
    [self removeFromSuperview];
    if (self.reloadBlock) {
        self.reloadBlock();
        self.reloadBlock = NULL;    //防止循环引用。
    }
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGFloat top = (self.superview.frame.size.height - (self.showsInFullScreen ? 0 : 64) - 250)/2.f;
    //画图片
    [[UIImage imageNamed:@"quan_wifi"] drawInRect:CGRectMake((kScreenWidth - 272/2.f)/2.f, top, 272/2.f, 226/2.f)];
    //画文字
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        [mDict setValue:style forKey:NSParagraphStyleAttributeName];
        [mDict setValue:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        [mDict setValue:UIColorFromRGB(0xa1a1a1) forKey:NSForegroundColorAttributeName];
        [@"请检查您的手机是否联网，点击按钮重新加载" drawInRect:CGRectMake(0, 160 + top, kScreenWidth, 15) withAttributes:mDict];
        [mDict setValue:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
        [mDict setValue:UIColorFromRGB(0xa1a1a1) forKey:NSForegroundColorAttributeName];
        [@"数据加载失败" drawInRect:CGRectMake(0, 130 + top, kScreenWidth, 17) withAttributes:mDict];

}


@end
