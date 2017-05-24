//
//  CustomersCollectionView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMainModel.h"

@interface CustomersCollectionView : UICollectionView
+ (CustomersCollectionView *)customersCollectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) OrderMainModel *orderMainModel;


@property(nonatomic,copy)void (^didselectItemsCustomersCollectionViewBlock)(NSString * title,NSString * gc_id);

@property(nonatomic,copy)void (^didselectItemsCustomersCollectionViewHeader_t_id_Block)(NSString * t_id);

@property(nonatomic,copy)void (^didselectItemsCustomersCollectionViewHeader_moreBtn_Block)();



@end
