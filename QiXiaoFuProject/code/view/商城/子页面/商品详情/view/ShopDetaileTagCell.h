//
//  ShopDetaileTagCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetaileModel.h"

@interface ShopDetaileTagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentsView;

@property (nonatomic, strong) GoodsDetaileModel *goodsDetaileModel;


@property (nonatomic, assign) CGFloat cellHeight;

@end
