//
//  YLSwitch.h
// QQ:896525689
// Email:zhangyuluios@163.com
//                 _
// /\   /\        | |
// \ \_/ / _   _  | |     _   _
//  \_ _/ | | | | | |    | | | |
//   / \  | |_| | | |__/\| |_| |
//   \_/   \__,_| |_|__,/ \__,_|
//
//  Created by shuogao on 16/6/24.
//  Copyright © 2016年 Yulu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YLSwitchDelegate <NSObject>

@optional

- (void)switchState:(NSInteger )state title:(NSString *)title;

@end

@interface YLSwitch : UIView
/**
 *  公开属性
 */
@property (nonatomic,strong) NSString *rightTitle;//右侧标题    默认为 second

@property (nonatomic,strong) NSString *leftTitle;//左侧标题     默认为 frist

@property (nonatomic,strong) UIColor *bgColor;//背景颜色        默认为 粉色

@property (nonatomic,strong) UIColor *thumbColor;//滑块颜色     默认为 白色

@property (nonatomic,weak) id <YLSwitchDelegate> delegate;//切换代理

//注：  多个YLSwitch代理方法请使用tag进行调用区分
- (void)jumpto:(NSInteger )index;

@end
