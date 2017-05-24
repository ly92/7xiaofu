//
//  DownMenuTopView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownMenuTopView : UIView

+ (DownMenuTopView *)downMenuTopView;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end
