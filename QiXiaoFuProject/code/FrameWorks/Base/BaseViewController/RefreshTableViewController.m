//
//  RefreshTableViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "RefreshTableViewController.h"
#import "MJRefresh.h"

@interface RefreshTableViewController ()

@property (nonatomic, readonly) UITableViewStyle style;


@end

@implementation RefreshTableViewController

@synthesize rightItems = _rightItems;

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _style = style;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:self.style];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = self.defaultFooterView;
    [self.view addSubview:_tableView];
    
    _page = 0;
    _showRefreshHeader = NO;
    _showRefreshFooter = NO;
    _showTableBlankView = NO;
    
    
//    UIView *view1 = [[UIView alloc] init];
//     UIView *view2 = [[UIView alloc] init];
//    [self.view addSubview:view1];
//    [self.view addSubview:view2];
//    
//    view1.translatesAutoresizingMaskIntoConstraints = NO;
//    view2.translatesAutoresizingMaskIntoConstraints = NO;
//    view1.backgroundColor = [UIColor blueColor];
//    view2.backgroundColor = [UIColor grayColor];
    
//    
//    //set view1 height and width
//    [view1 addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                      attribute:NSLayoutAttributeWidth
//                                                      relatedBy:NSLayoutRelationEqual
//                                                         toItem:nil
//                                                      attribute:NSLayoutAttributeNotAnAttribute
//                                                     multiplier:1
//                                                       constant:100]];
//    
//    [view1 addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                      attribute:NSLayoutAttributeHeight
//                                                      relatedBy:NSLayoutRelationEqual
//                                                         toItem:nil
//                                                      attribute:NSLayoutAttributeNotAnAttribute
//                                                     multiplier:1
//                                                       constant:100]];
//    
//    //set view2 height and width
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                          attribute:NSLayoutAttributeWidth
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:view1
//                                                          attribute:NSLayoutAttributeWidth
//                                                         multiplier:1
//                                                           constant:0]];
//    
////    item1.attribute =  multiplier * item2.attribute  +  constant。
//    
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                          attribute:NSLayoutAttributeHeight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:view1
//                                                          attribute:NSLayoutAttributeHeight
//                                                         multiplier:1
//                                                           constant:0]];
//    
//    //set relationship between view1 and view2
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view2
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:view1
//                                                          attribute:NSLayoutAttributeRight
//                                                         multiplier:1
//                                                           constant:100]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                          attribute:NSLayoutAttributeCenterY
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:view2
//                                                          attribute:NSLayoutAttributeCenterY
//                                                         multiplier:1
//                                                           constant:0]];
//    
//    //set relationship between topView and view1
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeLeading
//                                                         multiplier:1
//                                                           constant:20]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1
//                                                          attribute:NSLayoutAttributeCenterY
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeCenterY
//                                                         multiplier:1
//                                                           constant:0]];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter

- (void)setShowRefreshHeader:(BOOL)showRefreshHeader
{
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            __weak RefreshTableViewController *weakSelf = self;
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerHeaderRefresh];
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
            //            header.updatedTimeHidden = YES;
        }
        else{
            //            [self.tableView removeHeader];
        }
    }
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter
{
    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
            __weak RefreshTableViewController *weakSelf = self;
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerFooterRefresh];
                [weakSelf.tableView.mj_footer beginRefreshing];
            }];
        }
        else{
            //            [self.tableView removeFooter];
        }
    }
}

- (void)setShowTableBlankView:(BOOL)showTableBlankView
{
    if (_showTableBlankView != showTableBlankView) {
        _showTableBlankView = showTableBlankView;
    }
}

#pragma mark - getter

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableDictionary *)dataDictionary
{
    if (_dataDictionary == nil) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    
    return _dataDictionary;
}

- (UIView *)defaultFooterView
{
    if (_defaultFooterView == nil) {
        _defaultFooterView = [[UIView alloc] init];
    }
    return _defaultFooterView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KCELLDEFAULTHEIGHT;
}

#pragma mark - public refresh

- (void)autoTriggerHeaderRefresh
{
    if (self.showRefreshHeader) {
        [self tableViewDidTriggerHeaderRefresh];
    }
}

- (void)tableViewDidTriggerHeaderRefresh
{
    
}

- (void)tableViewDidTriggerFooterRefresh
{
    
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    __weak RefreshTableViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.tableView reloadData];
        }
        
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    });
}

@end
