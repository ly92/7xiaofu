//
//  GalenPayPasswordView.h
//  PayView
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GalenPasswordView.h"

#import "GalneProgressView.h"

@interface GalenPayPasswordView : UIView

@property ( nonatomic ,copy   ) NSString         *titleString;         /** 标题 */
/** 完成的回调block */
@property (nonatomic, copy) void (^inputPassFinish) (NSString *passWord);

@property (nonatomic, copy) void (^lessPassword) (void);

@property (nonatomic, strong) GalneProgressView *progressView;

/** 快速创建 */
+ (instancetype)tradeView;

/** 弹出 */
- (void)showInView:(UIView *)view;

- (void)hidenKeyboard:(void (^)(BOOL finished))completion;

-(void)showProgressView:(NSString *)infoStr;

-(void)showSuccess:(NSString *)infoStr;

-(void)hiddenPayPasswordView;
- (void)removeAllNumbers;



@end
