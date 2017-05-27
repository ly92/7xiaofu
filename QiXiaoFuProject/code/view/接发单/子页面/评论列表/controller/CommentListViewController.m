//
//  CommentListViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentCell.h"
#import "CommentModel.h"
#import "CommentReplyCell.h"
#import "CommentReplyViewController.h"
#import "CommentViewController.h"


@interface CommentListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, assign) NSInteger page;//页数
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem .title = @"评论列表";
    
//    if(_type == 1){
//        self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"评论" target:self action:@selector(commentItemAction:)];
//    }
    
    _dataArray = [NSMutableArray new];
    _page = 1;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    [_tableView registerNib:[UINib nibWithNibName:@"EngineerDetaileHeaderCell" bundle:nil] forCellReuseIdentifier:@"EngineerDetaileHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CommentReplyCell" bundle:nil] forCellReuseIdentifier:@"CommentReplyCell"];

    _tableView.tableFooterView = [UIView new];
    
    // Do any additional setup after loading the view from its nib.
    [self loadEngnieerCommentModelDataWithPage:1 hud:YES];
    
    [self addRefreshView];
    // Do any additional setup after loading the view from its nib.
}


- (void)loadEngnieerCommentModelDataWithPage:(NSInteger)page hud:(BOOL)hud{
    
    
    hud?[self showLoading]:nil;
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"curpage"] = @(page);//页数
    params[@"member_id"] = _member_id;//	工程师ID
        
    
    [MCNetTool postWithCacheUrl:HttpMainEngEvalList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page = page;
        _page ++;
        
        hud?[self dismissLoading]:nil;
        
        NSArray * array = [CommentModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        
        [_tableView reloadData];
        if (array.count < 10) {
            [_tableView hidenFooter];
        }
        page?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];;
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
        page?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];;
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
    }];
}

- (void)addRefreshView{
    [_tableView headerAddMJRefresh:^{
        [self loadEngnieerCommentModelDataWithPage:1 hud:NO];
    }];
    [_tableView footerAddMJRefresh:^{
        [self loadEngnieerCommentModelDataWithPage:_page hud:NO];
    }];
}

- (void)commentItemAction:(UIBarButtonItem *)item{

    CommentViewController * vc = [[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    vc.f_id = _member_id;
    vc.commentViewBlock =^(){
        
        [self loadEngnieerCommentModelDataWithPage:1 hud:YES];
        
    };
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CommentModel * commentModel = _dataArray[section];
    return 1 + commentModel.reply_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CommentModel * commentModel = _dataArray[indexPath.section];

    if (indexPath.row == 0) {
        CommentCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        cell.commentModel =commentModel;
        return cell;
    }else{
    
        Reply_List * reply_List =commentModel.reply_list[indexPath.row - 1];
        CommentReplyCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"CommentReplyCell"];
        cell.reply_List =reply_List;
        return cell;

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_type != 1){
    
        CommentModel * commentModel = _dataArray[indexPath.section];
        if (indexPath.row == 0) {
            
            
            [Utool verifyLogin:self LogonBlock:^{
                
                CommentReplyViewController * vc= [[CommentReplyViewController alloc]initWithNibName:@"CommentReplyViewController" bundle:nil];
                vc.parent_id = commentModel.eval_id;
                
                vc.commentReplyViewBlock=^(){
                    
                    [self loadEngnieerCommentModelDataWithPage:1 hud:YES];
                    
                };
                
                UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nvc animated:YES completion:^{
                    
                }];
                
                
            }];
            
            
        }
    
    
    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
