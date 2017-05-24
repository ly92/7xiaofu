//
//  UITableView+MJRefresh.h
//  Book
//
//  Created by 金波 on 15/12/27.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh/MJRefresh.h"

@interface UITableView (MJRefresh)

//添加顶部刷新
-(void)headerAddMJRefresh:(MJRefreshComponentRefreshingBlock)block;

//调用顶部刷新
-(void)headerBeginRefresh;

//取消顶部刷新状态
-(void)headerEndRefresh;

//添加底部刷新
-(void)footerAddMJRefresh:(MJRefreshComponentRefreshingBlock)block;

//调用底部刷新
-(void)footerBeginRefresh;

//取消底部刷新状态
-(void)footerEndRefresh;

//取消底部刷新状态并显示无数据
-(void)footerEndRefreshNoMoreData;

//重置无数据状态
-(void)footerResetNoMoreData;

// 隐藏tableView的底部视图
- (void)hidenFooter;

// 隐藏tableView的顶部控件
- (void)hidenHeader;

// 显示tableView的刷新控件
- (void)showHeader;

// 显示tableView的刷新控件
- (void)showFooter;

@end
