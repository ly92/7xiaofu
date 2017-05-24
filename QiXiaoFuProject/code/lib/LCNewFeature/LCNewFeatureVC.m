//
//  Created by 刘超 on 15/4/30.
//  Copyright (c) 2015年 Leo. All rights reserved.
//
//

#import "LCNewFeatureVC.h"
//#import "BlockButton.h"

// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface LCNewFeatureVC () <UIScrollViewDelegate> {
    
    /** 图片名 */
    NSString *_imageName;
    
    /** 图片个数 */
    NSInteger _imageCount;
    
    /** 分页控制器 */
    UIPageControl *_pageControl;
    
    /** 是否显示分页控制器 */
    BOOL _showPageControl;
    
    /** 进入主界面的按钮 */
    UIButton *_enterButton;
    
    /** 完成新特性界面展示后的block回调 */
    finishBlock _finishBlock;
}

@end



@implementation LCNewFeatureVC

#pragma mark - 是否显示新特性视图控制器

+ (BOOL)shouldShowNewFeature {
    
    NSString *key = @"CFBundleShortVersionString";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 获取沙盒中版本号
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获取当前的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        
        return NO;
        
    } else {
        
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        
        return YES;
    }
}

#pragma mark - 初始化新特性视图控制器



+ (instancetype)initWithImageName:(NSString *)imageName
                       imageCount:(NSInteger)imageCount
                  showPageControl:(BOOL)showPageControl
                      enterButton:(UIButton *)enterButton
                      finishBlock:(finishBlock)finishBlock{

    return [[self alloc] initWithImageName:imageName
                                imageCount:imageCount
                           showPageControl:showPageControl
                               enterButton:enterButton
                               finishBlock:finishBlock];

}
- (instancetype)initWithImageName:(NSString *)imageName
                       imageCount:(NSInteger)imageCount
                  showPageControl:(BOOL)showPageControl
                      enterButton:(UIButton *)enterButton
                      finishBlock:(finishBlock)finishBlock{

    if (self = [super init]) {
        
        _imageName = imageName;
        _imageCount = imageCount;
        _showPageControl = showPageControl;
        _enterButton = enterButton;
        _finishBlock = finishBlock;

        [self setupMainView];
    }
    
    return self;

}



- (instancetype)initWithImageName:(NSString *)imageName
                       imageCount:(NSInteger)imageCount
                  showPageControl:(BOOL)showPageControl
                      enterButton:(UIButton *)enterButton {
    
    if (self = [super init]) {
        
        _imageName = imageName;
        _imageCount = imageCount;
        _showPageControl = showPageControl;
        _enterButton = enterButton;
        
        [self setupMainView];
    }
    
    return self;
}

- (instancetype)initWithImageName:(NSString *)imageName
                       imageCount:(NSInteger)imageCount
                  showPageControl:(BOOL)showPageControl
                      finishBlock:(finishBlock)finishBlock {
    
    if (self = [super init]) {
        
        _imageName = imageName;
        _imageCount = imageCount;
        _showPageControl = showPageControl;
        _finishBlock = finishBlock;
        
        [self setupMainView];
    }
    
    return self;
}

#pragma mark 设置主界面

- (void)setupMainView {
    
    // 默认状态栏样式为黑色
    self.statusBarStyle = LCStatusBarStyleBlack;
    
    // 图片数组非空时
    if (_imageCount) {
        
        // 滚动视图
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView setDelegate:self];
        [scrollView setBounces:NO];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [scrollView setContentSize:(CGSize){SCREEN_SIZE.width * _imageCount, 0}];
        
        
        [self.view addSubview:scrollView];
        
        
        // 滚动图片
        CGFloat imageW = SCREEN_SIZE.width;
        CGFloat imageH = SCREEN_SIZE.height;
        
        for (int i = 0; i < _imageCount; i++) {
            
            CGFloat imageX = imageW * i;
            NSString *realImageName = [NSString stringWithFormat:@"%@_%d", _imageName, i + 1];
            UIImage *realImage = [UIImage imageNamedForAdaptation:realImageName iphone5:YES iphone6:YES iphone6p:YES];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImage:realImage];
            [imageView setFrame:(CGRect){imageX, 0, imageW, imageH}];
            [scrollView addSubview:imageView];
            
            if (_enterButton && i == _imageCount - 1) {
                
                [imageView setUserInteractionEnabled:YES];
                [imageView addSubview:_enterButton];
            }
        }
        
        // 分页视图
        if (_showPageControl) {
            
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            [pageControl setNumberOfPages:_imageCount];
            [pageControl setHidesForSinglePage:YES];
            [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
            [pageControl setCurrentPageIndicatorTintColor:[UIColor darkGrayColor]];
            [pageControl setFrame:(CGRect){0, SCREEN_SIZE.height * 0.9, SCREEN_SIZE.width, 37.0f}];
            [pageControl setValue:[UIImage imageNamed:@"dotH"] forKeyPath:@"currentPageImage"];
            [pageControl setValue:[UIImage imageNamed:@"dot"] forKeyPath:@"pageImage"];
            [self.view addSubview:pageControl];
            _pageControl = pageControl;
        }
        
    } else {
#ifdef DEBUG
        NSLog(@"警告: 请放入新特性图片!");
#endif
    }
}

#pragma mark - 新特性视图控制器的显示和消失

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    switch (self.statusBarStyle) {
            
        case LCStatusBarStyleBlack:
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            break;
            
        case LCStatusBarStyleWhite:
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            break;
            
        case LCStatusBarStyleNone:
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
            break;
            
        default:
            break;
    }
    
    if (_showPageControl) {
        
        // 如果设置了分页控制器当前点的颜色
        if (self.pointCurrentColor) {
            
            [_pageControl setCurrentPageIndicatorTintColor:self.pointCurrentColor];
        }
        
        // 如果设置了分页控制器其他点的颜色
        if (self.pointOtherColor) {
            
            [_pageControl setPageIndicatorTintColor:self.pointOtherColor];
        }
    }
}
- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    
    if (self.statusBarStyle == LCStatusBarStyleNone) {
        return YES;
    }
    return NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - UIScrollViewDelegate 方法

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // 最后一张再向左划的话
    if (scrollView.contentOffset.x == SCREEN_SIZE.width * (_imageCount - 1)) {
        if (_finishBlock) {
            _finishBlock(0);
        }
    }
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    
//    NSLog(@"----  %@",@(doublePage));

    // 设置页码
    _pageControl.currentPage = intPage;
    
    if (intPage == _imageCount-1) {
        _pageControl.hidden = YES;
    }else{
        _pageControl.hidden = NO;
    }
}

@end

#define IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation UIImage (LC)

+ (instancetype)imageNamedForAdaptation:(NSString *)imageName iphone5:(BOOL)iphone5 iphone6:(BOOL)iphone6 iphone6p:(BOOL)iphone6p {
    
    NSString *realImageName = imageName;
    
        if (IPHONE4) {
             realImageName = [NSString stringWithFormat:@"%@_iphone4", realImageName];
        }else
         // 当前设备是iPhone5\iPhone5S
        if (IPHONE5 && iphone5) {
            realImageName = [NSString stringWithFormat:@"%@_iphone5", realImageName];
        }else
        // 当前设备是iPhone6
        if (IPHONE6 && iphone6) {
            realImageName = [NSString stringWithFormat:@"%@_iphone6", realImageName];
        }else
    
        // 当前设备是iPhone6P
        if (IPHONE6P && iphone6p) {
    
            realImageName = [NSString stringWithFormat:@"%@_iphone6p", realImageName];
        }else{
            realImageName = [NSString stringWithFormat:@"%@_iphone6p", realImageName];
         }
    
    return [self imageNamed:realImageName];
}

@end
