//
//  KnowledgeViewController.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/8/15.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "UILabel+ContentSize.h"
#import "KnowledgeListCell.h"
#import "NSString+Extension.h"
#import "KnowledgeDetailViewController.h"
#import "KnowledgeChooseCell.h"

@interface KnowledgeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *topTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTableH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTableLeftDis;
@property (weak, nonatomic) IBOutlet UILabel *leftLbl;
@property (weak, nonatomic) IBOutlet UILabel *centerLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightLbl;


@property (nonatomic, copy) NSString *sortid;
@property (nonatomic, copy) NSString *typeid;

@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *topArray;//topTableView显示的数据
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;

@property (nonatomic, assign) NSUInteger leftIndex;

@property (nonatomic, strong) NSArray *sortArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation KnowledgeViewController

- (NSMutableArray *)leftArray{
    if(!_leftArray){
        _leftArray = [NSMutableArray array];
    }
    return _leftArray;
}

- (NSMutableArray *)topArray{
    if(!_topArray){
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}
-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortArray = @[@{@"id":@"1",@"name":@"按发布时间"},@{@"id":@"2",@"name":@"按点赞数量"}];
    self.leftIndex = 0;
    self.page = 1;
    self.typeid = @"0";
    self.sortid = @"0";
    
    [_tableView registerNib:[UINib nibWithNibName:@"KnowledgeListCell" bundle:nil] forCellReuseIdentifier:@"KnowledgeListCell"];
    [self.topTableView registerNib:[UINib nibWithNibName:@"KnowledgeChooseCell" bundle:nil] forCellReuseIdentifier:@"KnowledgeChooseCell"];
    
    [self loadSortData];
    
    [self addRefsh];
    [self loadData];
    
}
- (IBAction)hideTopTable {
    self.leftBtn.selected = NO;
    self.centerBtn.selected = NO;
    self.rightBtn.selected = NO;
    self.topTableView.hidden = YES;
    self.bgBtn.hidden = YES;
}

#pragma mark - 刷新
- (void)addRefsh{
     _tableView.tableFooterView = [UIView new];
    
    [_tableView headerAddMJRefresh:^{
        self.page = 1;
        [self loadData];
    }];
    
    [_tableView footerAddMJRefresh:^{
        self.page += 1;
        [self loadData];
    }];
}

- (IBAction)topBtnAction:(UIButton *)btn {
    if (btn.selected){
        [self hideTopTable];
        return;
    }
    self.leftBtn.selected = NO;
    self.centerBtn.selected = NO;
    self.rightBtn.selected = NO;
    btn.selected = true;
    self.topTableLeftDis.constant = btn.x;
    self.topTableView.hidden = NO;
    self.bgBtn.hidden = NO;
    
    [self.topArray removeAllObjects];
    
    if (btn.tag == 11){
        [self.topArray addObjectsFromArray:self.leftArray];
    }else if (btn.tag == 22){
        if (self.leftArray.count > self.leftIndex){
            NSDictionary *dict = self.leftArray[self.leftIndex];
            self.leftLbl.text = [dict objectForKey:@"name"];
            [self.topArray addObjectsFromArray:dict[@"smallList"]];
        }
    }else{
        [self.topArray addObjectsFromArray:self.sortArray];
    }
    
    if (self.topArray.count > 0){
        if (self.topArray.count < 4){
            self.topTableH.constant = self.topArray.count * 44;
        }else{
            self.topTableH.constant = 150;
        }
        [self.topTableView reloadData];
    }else{
        self.topTableView.hidden = YES;
        btn.selected = NO;
        self.bgBtn.hidden = YES;
    }
    
    
}

//获取筛选条件
- (void)loadSortData{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    
    [MCNetTool postWithUrl:@"tp.php/Home/RepositoryType/index" params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self.leftArray removeAllObjects];
        [self.leftArray addObjectsFromArray:(NSArray *)requestDic];
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];

}

//获取知识库数据
- (void)loadData{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"type_id"] = self.typeid;
    params[@"sortid"] = self.sortid;
    params[@"curpage"] = @(self.page);
    
    [MCNetTool postWithUrl:@"tp.php/Home/RepositoryType/seachpost" params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        if (self.page == 1){
            [self.dataArray removeAllObjects];
            [_tableView headerEndRefresh];
        }else{
            [_tableView footerEndRefresh];
        }
        
        NSArray *array = (NSArray *)requestDic;
        [self.dataArray addObjectsFromArray:array];

        
        
        [_tableView reloadData];
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:self.dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
        if (array.count < 10){
            [_tableView hidenFooter];
        }
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
        self.page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:self.dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}



#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.topTableView){
        return self.topArray.count;
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.topTableView){
        KnowledgeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KnowledgeChooseCell" forIndexPath:indexPath];
        cell.titleLbl.textColor = [UIColor colorWithHexColorString:@"737373"];
        cell.titleLbl.backgroundColor = [UIColor whiteColor];
        
        if (self.topArray.count > indexPath.row){
            NSDictionary *dict = self.topArray[indexPath.row];
            cell.titleLbl.text = [dict objectForKey:@"name"];
        }
        return cell;
    }else{
        KnowledgeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KnowledgeListCell" forIndexPath:indexPath];
        if (self.dataArray.count > indexPath.row){
            NSDictionary *dict = self.dataArray[indexPath.row];
            [cell.iconImgV setImageWithUrl:[dict objectForKey:@"user_avatar"] placeholder:kDefaultImage_header];
            cell.nameLbl.text = [dict objectForKey:@"nik_name"];
            cell.titleLbl.text = [dict objectForKey:@"post_title"];
            cell.contentLbl.text = [dict objectForKey:@"post_content"];
            cell.agreeLbl.text = [NSString stringWithFormat:@"%@赞",[dict objectForKey:@"upvote_num"]];
             NSDate *time = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"input_time"] doubleValue]];
            if ([time isToday]){
                if ([time hoursBeforeDate:[NSDate date]] > 0){
                    cell.timeLbl.text = [NSString stringWithFormat:@"%ld小时前",(long)[time hoursBeforeDate:[NSDate date]]];
                }else if ([time minutesBeforeDate:[NSDate date]] > 0){
                    cell.timeLbl.text = [NSString stringWithFormat:@"%ld分钟前",(long)[time minutesBeforeDate:[NSDate date]]];
                }else{
                    cell.timeLbl.text = @"刚刚";
                }
            }else if ([time isYesterday]){
                cell.timeLbl.text =  [NSString stringWithFormat:@"昨天 %@",[Utool messageIndex_timeStamp2TimeFormatter:[dict objectForKey:@"input_time"]]];
            }else{
                cell.timeLbl.text = [Utool timeStampPointTimeFormatter:[dict objectForKey:@"input_time"]];
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.topTableView){
        return 44;
    }else{
        if (self.dataArray.count > indexPath.row){
            NSDictionary *dict = self.dataArray[indexPath.row];
            NSString *content = [dict objectForKey:@"post_content"];
            CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(kScreenWidth-16, MAXFLOAT)];
            if (size.height > 62){
                return 170;
            }
            return size.height + 108;
        }
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == self.topTableView){
        if (self.topArray.count > indexPath.row){
            NSDictionary *dict = self.topArray[indexPath.row];
            
            if (self.leftBtn.selected){
                self.leftIndex = indexPath.row;
                self.leftLbl.text = [dict objectForKey:@"name"];
                self.centerLbl.text = @"所有品牌";
                self.typeid = [dict objectForKey:@"id"];
            }else if (self.centerBtn.selected){
                self.centerLbl.text = [dict objectForKey:@"name"];
                self.typeid = [dict objectForKey:@"id"];
            }else{
                self.rightLbl.text = [dict objectForKey:@"name"];
                self.sortid = [dict objectForKey:@"id"];
            }
            [self hideTopTable];
            [self loadData];
            self.page = 1;
        }
    }else{
        if (self.dataArray.count > indexPath.row){
            NSDictionary *dict = self.dataArray[indexPath.row];
            KnowledgeDetailViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KnowledgeDetailViewController"];
            VC.postId = [dict objectForKey:@"post_id"];
            [self.navigationController pushViewController:VC animated:true];
        }
    }
}


@end
