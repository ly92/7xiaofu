//
//  PPNumberButton.h
//  PPNumberButton
//
//  Created by AndyPang on 16/8/31.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPNumberButtonDelegate <NSObject>

@optional
- (void)PPNumberButton:(UIView *)numberButton number:(NSString *)number;
@end



@interface PPNumberButton : UIView

/** 加减按钮的回调*/
@property (nonatomic, copy) void(^numberBlock)(NSString *number);
/** 代理*/
@property (nonatomic, weak) id<PPNumberButtonDelegate> delegate;

/**
 *  通过类方法创建一个按钮实例对象
 *
 *  @param frame 按钮的尺寸
 *
 *  @return 返回一个PPNumberButton的实例对象
 */
+ (instancetype)numberButtonWithFrame:(CGRect)frame;


#pragma mark - 自定义样式设置

/** 设置边框的颜色,如果没有设置颜色,就没有边框*/
@property (nonatomic, strong) UIColor *borderColor;

/** 是否开启旋转动画,默认NO*/
@property (nonatomic, assign, getter=isShakeAnimation) BOOL shakeAnimation;

/** 获取/设置当前输入框的内容*/
@property (nonatomic, copy) NSString *currentNumber;

/** 加减按钮的字体属性*/
@property (nonatomic, strong) UIFont *font;


/** 是不是需要手动输入数字*/
@property (nonatomic, assign) BOOL input;

/** 允许输入的最小数字数字 默认为 0 */
@property (nonatomic, assign) NSInteger minNum;

/** 允许输入的最大数字数字*/
@property (nonatomic, assign) NSInteger maxNum;



//注意:加减号按钮的标题和背景图片只能设置其中一个,若全部设置,则以最后设置的类型为准
/**
 *  设置加/减按钮的标题
 *
 *  @param increaseTitle 加按钮标题
 *  @param decreaseTitle 减按钮标题
 */
- (void)setTitleWithIncreaseTitle:(NSString *)increaseTitle decreaseTitle:(NSString *)decreaseTitle;

/**
 *  设置加/减按钮的背景图片
 *
 *  @param increaseImage 加按钮背景图片
 *  @param decreaseImage 减按钮背景图片
 */
- (void)setImageWithIncreaseImage:(UIImage *)increaseImage decreaseImage:(UIImage *)decreaseImage;


@end
