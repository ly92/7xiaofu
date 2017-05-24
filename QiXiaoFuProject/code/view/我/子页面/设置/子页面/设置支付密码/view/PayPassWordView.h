//
//  PayPassWordView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PayPassWordView : UIView

@property (copy, nonatomic) NSString *title;                        ///< 标题
@property (copy, nonatomic) NSString *trueBtntitle;                  ///< 确认按钮标题
@property (assign, nonatomic) NSUInteger length;                    ///< 密码长度
@property (copy, nonatomic) void (^completeAction)(NSString *text); ///< 回调 Block
- (void)showView:(UIView *)view;
@end
