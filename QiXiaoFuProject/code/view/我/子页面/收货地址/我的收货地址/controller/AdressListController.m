//
//  AdressListController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "AdressListController.h"
#import "AdressCell.h"
#import "EditAdressController.h"
#import "BlockUIAlertView.h"


@interface AdressListController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;

@end

@implementation AdressListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收货地址";
    
    
    _dataArray = [NSMutableArray new];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"添加" target:self action:@selector(addItemAction:)];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    [self.tableView registerNib:[UINib nibWithNibName:@"AdressCell" bundle:nil] forCellReuseIdentifier:@"AdressCell"];
    _tableView.tableFooterView = [UIView new];
    
    
    
    

    [_tableView headerAddMJRefresh:^{
        
        [self loadAdressListRefresh:YES];
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self loadAdressListRefresh:NO];


}



- (void)loadAdressListRefresh:(BOOL )refresh{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    
    [MCNetTool postWithUrl:HttpAdressList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _dataArray = [AdressModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        [_tableView reloadData];
        
        refresh?[_tableView headerEndRefresh]:@"";
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewAdress withScrollView:_tableView];
        
        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
        refresh?[_tableView headerEndRefresh]:@"";
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewAdress withScrollView:_tableView];

    }];
    


}

#pragma mark - 添加收货地址
- (void)addItemAction:(UIBarButtonItem *)item{
    
    EditAdressController * vc = [[EditAdressController alloc]initWithNibName:@"EditAdressController" bundle:nil];
    vc.isEdit = 1;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdressCell *cell =[tableView dequeueReusableCellWithIdentifier:@"AdressCell"];
    
    AdressModel * adressModel = _dataArray[indexPath.section];
    cell.adressModel = adressModel;
    cell.indexPath = indexPath;
    // 编辑收货地址
    [cell.editBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
       
        AdressModel * _adressModel = _dataArray[btn.tag];
        EditAdressController * vc = [[EditAdressController alloc]initWithNibName:@"EditAdressController" bundle:nil];
        vc.isEdit = 2;
        vc.adressModel =_adressModel;
        
        vc.editAdressBlock= ^(){
        
            [self loadAdressListRefresh:NO];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
 
        
    }];
    
    // 删除收货地址
    [cell.deleteBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除收货地址吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                
                AdressModel * _adressModel = _dataArray[btn.tag];

                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"store_id"] = @"1";
                params[@"address_id"] = _adressModel.address_id;;
                
                [MCNetTool postWithCacheUrl:HttpDelAdress params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    [self showSuccessText:msg];
                    [_dataArray removeObjectAtIndex:btn.tag];//移除数据源的数据
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:btn.tag];
                    [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];//移除tableView中的section
         
                    [_tableView reloadData];
                    
                } fail:^(NSString *error) {
                    
                    [self showErrorText:error];
                }];

            }
            
        } otherButtonTitles:@"删除"];
        [alert show];

        
        
    }];
    
    [cell.defaultAdressBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
       
        AdressModel * _adressModel = _dataArray[btn.tag];

        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = kUserId;
        params[@"store_id"] = @"1";
        params[@"address_id"] = _adressModel.address_id;

        [MCNetTool postWithCacheUrl:HttpSetDefaultAdress params:params success:^(NSDictionary *requestDic, NSString *msg) {
            
            [self showSuccessText:msg];
            
            btn.selected = !btn.selected;
            
            [self loadAdressListRefresh:NO];
            
            
        } fail:^(NSString *error) {
            
            [self showErrorText:error];
        }];
        
    }];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(_type == 2){
        AdressModel * adressModel = _dataArray[indexPath.section];
        if (_adressListVCBlock) {
            _adressListVCBlock(adressModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
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
