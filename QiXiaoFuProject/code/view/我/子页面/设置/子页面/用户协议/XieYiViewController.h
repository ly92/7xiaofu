//
//  XieYiViewController.h
//  八爪鱼
//
//  Created by 冯洪建 on 16/1/2.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "BaseViewController.h"

@interface XieYiViewController : BaseViewController
@property (nonatomic,assign)NSInteger  type;// 1 注册协议 2 操作手册  3 加入我们  4查看物流
@property (nonatomic,copy)NSString  *orderId;// 查看物流   订单id

@end
