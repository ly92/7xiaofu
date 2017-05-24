//
//  CLAdCollectionCell.h
//  Budayang
//
//  Created by darren on 16/4/12.
//  Copyright © 2016年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickLable1Block)();

@interface CLAdCollectionCell : UICollectionViewCell

/**广告图片模型*/
 @property (nonatomic,strong) NSArray *contentArray;

@property (nonatomic,strong) UILabel *lableContent1;

@property (nonatomic,copy) clickLable1Block clickLable1;


@end
