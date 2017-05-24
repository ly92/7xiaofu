//
//  JieFanDanZaiCiPayViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface JieFanDanZaiCiPayViewController : BaseViewController
@property (nonatomic, copy) NSString *f_id;
@property (nonatomic, assign) CGFloat order_price;

@property (nonatomic, assign) CGFloat tioajia_order_price;



//@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, assign) NSInteger type;// 1  接发单再次支付  2  调价支付

@property (nonatomic, strong) NSArray * tiaojiaImageUrlArray;// 调价上传的图片数组


@property(nonatomic, copy) void (^jieFanDanZaiCiPayViewBlock)();



@end
