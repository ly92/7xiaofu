//
//  Created by 刘超 on 15/4/30.
//  Copyright (c) 2015年 Leo. All rights reserved.
//
//  Email : leoios@sina.com
//  GitHub: http://github.com/LeoiOS
//  如有问题或建议请给我发Email, 或在该项目的GitHub主页lssues我, 谢谢:)
//


#import <UIKit/UIKit.h>

/**
 *  完成新特性界面展示后的block回调
 */
typedef void (^finishBlock)(NSInteger tag);

/**
 *  状态栏样式
 */
typedef NS_ENUM(NSInteger, LCStatusBarStyle) {
    /** 黑色 */
    LCStatusBarStyleBlack,
    /** 白色 */
    LCStatusBarStyleWhite,
    /** 隐藏 */
    LCStatusBarStyleNone
};

@interface LCNewFeatureVC : UIViewController


#pragma mark - 属性 Properties

/**
 *  当前点(分页控制器)的颜色
 */
@property (nonatomic, strong) UIColor *pointCurrentColor;
/**
 *  其他点(分页控制器)的颜色
 */
@property (nonatomic, strong) UIColor *pointOtherColor;
/**
 *  状态栏样式, 请先参考`必读`第3条设置
 */
@property (nonatomic, assign) LCStatusBarStyle statusBarStyle;

#pragma mark - 方法 Methods

/**
 *  是否显示新特性视图控制器, 对比版本号得知
 */
+ (BOOL)shouldShowNewFeature;



/**
 *  初始化新特性视图控制器, 实例方法
 *
 *  @param imageName 图片名, 请将原图名称修改为该格式: `<imageName>_1`, `<imageName>_2`... 如: `NewFeature_1@2x.png`
 *
 *  @param finishBlock 完成新特性界面展示后的回调
 *
 *  @return 初始化的控制器实例
 */
- (instancetype)initWithImageName:(NSString *)imageName
                       imageCount:(NSInteger)imageCount
                  showPageControl:(BOOL)showPageControl
                      enterButton:(UIButton *)enterButton;


 

- (instancetype)initWithImageName:(NSString *)imageName
                       imageCount:(NSInteger)imageCount
                  showPageControl:(BOOL)showPageControl
                      finishBlock:(finishBlock)finishBlock;




+ (instancetype)initWithImageName:(NSString *)imageName
                       imageCount:(NSInteger)imageCount
                  showPageControl:(BOOL)showPageControl
                      enterButton:(UIButton *)enterButton
                      finishBlock:(finishBlock)finishBlock;


- (instancetype)initWithImageName:(NSString *)imageName
                       imageCount:(NSInteger)imageCount
                  showPageControl:(BOOL)showPageControl
                      enterButton:(UIButton *)enterButton
                      finishBlock:(finishBlock)finishBlock;


@end

@interface UIImage (LC)

/**
 *  初始化一张适配iPhone屏幕尺寸的图片, 类方法
 *
 *  @param imageName 图片名称
 *
 *  @param iphone5 是否有iPhone5的图片, 默认`NO`, 无图片; 有图片请参考命名: `<name>_iphone5`, 如: `Apple_iphone5h@2x.png`
 *
 *  @param iphone6 是否有iPhone6的图片, 默认`NO`, 无图片; 有图片请参考命名: `<name>_iphone6`, 如: `Apple_iphone6@2x.png`
 *
 *  @param iphone6p 是否有iPhone6P的图片, 默认`NO`, 无图片; 有图片请参考命名: `<name>_iphone6p`, 如: `Apple_iphone6p@2x.png`
 */
+ (instancetype)imageNamedForAdaptation:(NSString *)imageName iphone5:(BOOL)iphone5 iphone6:(BOOL)iphone6 iphone6p:(BOOL)iphone6p;

@end