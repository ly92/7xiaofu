//
//  RefreshTableViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

#define KCELLDEFAULTHEIGHT 50


@interface RefreshTableViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_rightItems;
}

@property (strong, nonatomic) NSArray *rightItems;
@property (strong, nonatomic) UIView *defaultFooterView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) int page;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;

@property (nonatomic) BOOL showRefreshHeader;
@property (nonatomic) BOOL showRefreshFooter;
@property (nonatomic) BOOL showTableBlankView;

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (void)tableViewDidTriggerHeaderRefresh;
- (void)tableViewDidTriggerFooterRefresh;

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;


@end
