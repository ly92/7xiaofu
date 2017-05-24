//
//  FL_WaterFallLayout.h
//  瀑布流
//
//  Created by ln on 15/11/4.
//  Copyright © 2015年 fancyLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FL_WaterFallLayout;
@protocol FL_WaterFallLayoutDelegate <NSObject>

@required
//计算高度
-(CGFloat)waterFlowLayout:(FL_WaterFallLayout*)waterFlowLayout heightForWidth:(CGFloat)width indexPath:(NSIndexPath*)indexPath;

@end


@interface FL_WaterFallLayout : UICollectionViewLayout


//每一行的间距
@property (nonatomic, assign) CGFloat rowMargin;
//列间距
@property (nonatomic, assign) CGFloat columnMargin;
//允许的最大列数
@property (nonatomic, assign) CGFloat columnCount;
//四边间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;
//实现FL_WaterFallLayoutDelegate协议
@property (nonatomic, weak) id<FL_WaterFallLayoutDelegate>delegate;

@end
