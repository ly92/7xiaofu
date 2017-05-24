//
//  CLHomeHeader.h
//  CLZhongZi
//
//  Created by darren on 16/3/7.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void(^ClickCellBlock)();
//typedef void(^ClickCellMoreBtnBlock)();

@interface CLHomeHeader : UIView

@property (nonatomic, strong) NSArray *newses;

// 放在外部是为了切换另一个页面时，关闭定时器
@property(nonatomic,strong) NSTimer *timer;
- (void)removeTimer;
- (void)addTimer;

//@property (nonatomic,copy) ClickCellBlock clickCellBlock;
//@property (nonatomic,copy) ClickCellMoreBtnBlock clickCellMoreBtnBlock;


@property(nonatomic,copy)void (^clickCellBlock)(NSString * t_id);
@property(nonatomic,copy)void (^clickCellMoreBtnBlock)(NSString * t_id);


@end
