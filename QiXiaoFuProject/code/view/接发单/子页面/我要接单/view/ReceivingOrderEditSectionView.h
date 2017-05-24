//
//  ReceivingOrderEditSectionView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivingOrderEditSectionView : UIView
+ (ReceivingOrderEditSectionView *)receivingOrderEditSectionView;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@end
