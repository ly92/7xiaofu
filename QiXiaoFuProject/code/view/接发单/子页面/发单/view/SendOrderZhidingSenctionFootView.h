//
//  SendOrderZhidingSenctionFootView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendOrderZhidingSenctionFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

+ (SendOrderZhidingSenctionFootView *)sendOrderZhidingSenctionFootView;

@end
