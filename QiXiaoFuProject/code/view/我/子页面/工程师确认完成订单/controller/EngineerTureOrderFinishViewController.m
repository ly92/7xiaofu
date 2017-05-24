//
//  EngineerTureOrderFinishViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerTureOrderFinishViewController.h"
#import "EngineerTureOrderFinishCheckCell.h"
#import "SendOrderFooterView.h"
#import "ChooseSNNumViewController.h"
#import "NSArray+Utils.h"


@interface EngineerTureOrderFinishViewController (){

    NSString * _sn_num;
    NSString * _sn_id;
    
    NSMutableDictionary * _selectDictionary;// 用于存储已经选择的sn码

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * datArray;

@end

@implementation EngineerTureOrderFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"确认完成";
    
    _datArray = [NSMutableArray new];
    _selectDictionary = [NSMutableDictionary new];
    _sn_id =@"";
    _sn_num = @"请选择备件sn码";

    [_tableView registerNib:[UINib nibWithNibName:@"EngineerTureOrderFinishCheckCell" bundle:nil] forCellReuseIdentifier:@"EngineerTureOrderFinishCheckCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EngineerTureOrderFinishInputCell"];

    
    SendOrderFooterView * sendOrderFooterView = [SendOrderFooterView sendOrderFooterView];
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    [footerView addSubview:sendOrderFooterView];
    sendOrderFooterView.frame = footerView.bounds;
    _tableView.tableFooterView = footerView;
    
    [sendOrderFooterView.trueSendOrderBtn setTitle:@"确认完成" forState:UIControlStateNormal];
    [sendOrderFooterView.trueSendOrderBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = kUserId;
        params[@"id"] = _f_id;
        if (_datArray.count == 1) {
            
            if (_sn_id.length==0) {
                [self showErrorText:@"请选择使用备件的sn码"];
                return ;
            }else{
                params[@"goods_id"] = _sn_id;
             }
        }
        
        NSString * url ;
        
        if(_type == 1){
        
            url  = HttpMeEngSuccBill;
        }else{
            url  = HttpMeEngComBill;

        }
        
        [MCNetTool postWithUrl:url params:params success:^(NSDictionary *requestDic, NSString *msg) {
            [self showSuccessText:@"订单已完成"];
            
            if (_engineerTureOrderFinishViewBlock) {
                _engineerTureOrderFinishViewBlock();
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];
        
        
    }];

    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _datArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 0) {
        
       __weak EngineerTureOrderFinishCheckCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EngineerTureOrderFinishCheckCell"];
        cell.lineView.hidden = YES;
        cell.checkBtnCellBlobk = ^(NSInteger type){
            
            if (type ==2) {
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_datArray.count inSection:1];
                [indexPaths addObject: indexPath];
                [_datArray addObject:@"  "];
                //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableView endUpdates];
                cell.lineView.hidden = NO;
            }else{
                [_datArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:1];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath1] withRowAnimation:UITableViewRowAnimationMiddle];//移除tableView中
                cell.lineView.hidden = YES;
            }
        };
        return cell;
    }
    
    
    UITableViewCell * cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"EngineerTureOrderFinishInputCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text =@"备件SN码";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.text = _sn_num;

    return cell;

 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return  101;
     }
    return  50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        ChooseSNNumViewController * vc = [[ChooseSNNumViewController alloc]initWithNibName:@"ChooseSNNumViewController" bundle:nil];
        vc.selectDict = _selectDictionary;
        vc.chooseSNNumBlock = ^(NSMutableDictionary * selectDict){
            
            _selectDictionary = selectDict;
            //            _sn_num = sn;
            _sn_num = [NSString stringWithFormat:@"共选择%ld个",selectDict.allKeys.count];
            _sn_id = [selectDict.allKeys string];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"共选择%ld个",selectDict.allKeys.count];
            
        };
        
//        vc.chooseSNNumBlock = ^(NSString * sn,NSString * sn_id){
////            _sn_num = sn;
//            _sn_num = [NSString stringWithFormat:@"共选择%@个",sn];
//            _sn_id = sn_id;
//            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"共选择%@个",sn];
//
//        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 ) {
        return 10.0;
    }
    return 0.001f;
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
