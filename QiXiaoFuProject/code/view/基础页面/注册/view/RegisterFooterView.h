//
//  RegisterFooterView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterFooterView : UIView
+ (RegisterFooterView *)registerFooterView;
@property (weak, nonatomic) IBOutlet UILabel *protocolLab;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;



@end
