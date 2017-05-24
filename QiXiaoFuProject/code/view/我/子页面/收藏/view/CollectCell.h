//
//  CollectCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopListModel.h"
#import "CollectGoodModel.h"

@interface CollectCell : UICollectionViewCell

@property (nonatomic, strong) Goods_List *good_list;


@property (nonatomic, strong) CollectGoodModel * collectGoodModel;


@end
