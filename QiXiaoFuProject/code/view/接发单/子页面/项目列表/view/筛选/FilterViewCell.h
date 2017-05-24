//
//  AF_BrandCell.h
//  差五个让步
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 Elephant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewCellDelegate <NSObject>

- (void)selectedValueChangeBlock:(NSInteger)section key:(NSInteger)index value:(NSString *)value;

@end

@interface FilterViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (assign, nonatomic) id<FilterViewCellDelegate> delegate;

@property (strong, nonatomic) NSArray *attributeArr;

@property (strong, nonatomic) NSMutableArray *selectedArr;

@property (assign, nonatomic) CGFloat height;

/** cell 的类方法   返回 cell 本身  */
+ (instancetype) cellWithTableView: (UITableView *)tableView dataArr:(NSArray*)arr indexPath:(NSIndexPath *)indexPath;
@end
