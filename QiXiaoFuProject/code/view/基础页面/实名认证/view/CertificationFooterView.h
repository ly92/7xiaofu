//
//  CertificationFooterView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertificationFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *frontBtn;
@property (weak, nonatomic) IBOutlet UIButton *tailBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
+ (CertificationFooterView *)certificationFooterView;

@end
