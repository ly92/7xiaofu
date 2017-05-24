//
//  SortTableView.h
//  PrettyFactoryProject
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopListModel.h"

@interface SortTableView : UITableView
+ (SortTableView *)contentTableView;
@property (nonatomic, copy) void (^didSelectRow)(Value *  value);
@property (nonatomic, copy) void (^didDismisView)(NSInteger type);

@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, assign) NSInteger type;// 0 left  2 right

@end
