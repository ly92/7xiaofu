//
//  EngineerCollectionView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMainModel.h"

@interface EngineerCollectionView : UICollectionView
+ (EngineerCollectionView *)engineerCollectionView;



@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) OrderMainModel *orderMainModel;

@property(nonatomic,copy)void (^didselectItemsEngineerCollectionViewBlock)(NSString * title,NSString * gc_id);

@property(nonatomic,copy)void (^didselectItemsEngineerCollectionViewHeader_t_id_Block)(NSString * t_id);

@property(nonatomic,copy)void (^didselectItemsEngineerCollectionViewHeader_moreBtn_Block)();
@end
