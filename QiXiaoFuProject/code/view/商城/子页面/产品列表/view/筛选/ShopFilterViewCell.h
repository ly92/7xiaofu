//
//  ShopFilterViewCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ShopFilterViewCellDelegate <NSObject>

- (void)selectedValueChangeBlock:(NSInteger)section key:(NSInteger)index value:(NSString *)value;

@end

@interface ShopFilterViewCell : UITableViewCell
@property (assign, nonatomic) id<ShopFilterViewCellDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *attributeArr;

@property (strong, nonatomic) NSMutableArray *selectedArr;

@property (assign, nonatomic) CGFloat height;

/** cell 的类方法   返回 cell 本身  */
+ (instancetype) cellWithTableView: (UITableView *)tableView dataArray:(NSMutableArray*)arr indexPath:(NSIndexPath *)indexPath;

@end
