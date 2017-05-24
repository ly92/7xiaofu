//
//  OrderDetaileKeHuContentCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetaileKeHuContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;
@property (weak, nonatomic) IBOutlet UIView *ImagebgView;


@property (nonatomic, assign) CGFloat service_price;

@property(nonatomic, copy) void (^orderDetaileKeHuContentCellBlock)(NSString * price);

@property(nonatomic, copy) void (^orderDetaileKeHuContentImageArrayCellBlock)(NSArray * imageArray);

@end
