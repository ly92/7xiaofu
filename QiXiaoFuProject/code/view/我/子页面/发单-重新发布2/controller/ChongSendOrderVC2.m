//
//  ChongSendOrderVC2.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChongSendOrderVC2.h"
#import "SendOrderFooterView.h"
#import "SendOrder1Cell.h"
#import "SendOrderSwitchCell.h"
#import "SendOrderZhidingSenctionFootView.h"
#import "SendOrder1UpImageCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "PayViewController.h"

/*
 
 
                重新发布
 
 
 */

@interface ChongSendOrderVC2 ()


@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, strong) NSMutableArray *quyuArray;

@property (nonatomic, strong) SendOrderZhidingSenctionFootView * sendOrderZhidingSenctionFootView;

@end

@implementation ChongSendOrderVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发单";
    
    _quyuArray = [NSMutableArray new];
    [_quyuArray addObject:@"0"];
    [_quyuArray addObject:@"1"];
    [_quyuArray addObject:@"2"];
    

    
    SendOrderFooterView * sendOrderFooterView = [SendOrderFooterView sendOrderFooterView];
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    [footerView addSubview:sendOrderFooterView];
    sendOrderFooterView.frame = footerView.bounds;
    _tableView.tableFooterView = footerView;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrder1Cell" bundle:nil] forCellReuseIdentifier:@"SendOrder1Cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderSwitchCell" bundle:nil] forCellReuseIdentifier:@"SendOrderSwitchCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrder1UpImageCell" bundle:nil] forCellReuseIdentifier:@"SendOrder1UpImageCell"];
    
    
    [sendOrderFooterView.trueSendOrderBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
   
        [MCNetTool postWithUrl:HttpMeReSetBill params:_requestParams success:^(NSDictionary *requestDic, NSString *msg) {
            
            [self showSuccessText:@"发布成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];
        
        
//        PayViewController * vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
//        vc.requestParams = _requestParams;
////        vc.showaddbillModel = _showaddbillModel;
//        vc.isTop = _isTop;
//        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _quyuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row ==0) {
        
        SendOrder1Cell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrder1Cell"];
        cell.textView.placeholder = @"请输入备注内容";
        cell.textView.text = _chongSendOrderModel.bill_desc;
        cell.textView.completionBlock =^(NSString * text){
            _requestParams[@"bill_desc"] = text;//备注
        };
        return cell;
    }
    
    if (indexPath.row == 1) {
        SendOrder1UpImageCell *   cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrder1UpImageCell"];
        cell.type =2;
        //cell.imageArray= _chongSendOrderModel.image;
        cell.sendOrder1UpImageCellBlock = ^(NSMutableArray * imageArray){
            _requestParams[@"images"] = imageArray;//图片一维数组【 通过通过接口上传图片接口获取到的URL 】
        };
        return cell;
    }
    
//    if (indexPath.row ==2) {
//        SendOrderSwitchCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderSwitchCell"];
//        cell.titleLab.text =@"置顶显示";
//        cell.textField.hidden = YES;
//        cell.zhidingSwitch.hidden = NO;
//        cell.zhidingSwitch.on = NO;
//        
//        cell.zhidingSwitchBlock =^(BOOL on){
//            
//            _isTop = on;
//            
//            if (on) {
//                
//                _sendOrderZhidingSenctionFootView.priceLab.hidden = NO;;
//                _sendOrderZhidingSenctionFootView.timeLab.hidden = NO;
//                
//                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_quyuArray.count inSection:0];
//                
//                [indexPaths addObject: indexPath];
//                [_quyuArray addObject:@"3"];
//                
//                //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
//                [self.tableView beginUpdates];
//                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                [self.tableView endUpdates];
//                
//            }else{
//                _sendOrderZhidingSenctionFootView.priceLab.hidden = YES;;
//                _sendOrderZhidingSenctionFootView.timeLab.hidden = YES;
//                
//                [_quyuArray removeObject:@"3"];
//                
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//                
//                //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
//                [self.tableView beginUpdates];
//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
//                [self.tableView endUpdates];
//                
//            }
//            
//        };
//        
//        return cell;
//    }
    if (indexPath.row ==2) {
        SendOrderSwitchCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderSwitchCell"];
        cell.titleLab.text =@"置顶天数";
        cell.zhidingSwitch.hidden = YES;
        cell.textField.hidden = NO;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.text = @"0";//_chongSendOrderModel.top_day;
        cell.textField.userInteractionEnabled = NO;
        cell.textFieldBlock= ^(NSString * text){
            _requestParams[@"top_day"] = text;//置顶天数
        };
        //
        return cell;
    }
    return nil;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return  150;
    }
    if (indexPath.row == 1) {
        return  (kScreenWidth - 0 - 60) / 5 + 20;
    }
    return  44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if(section ==0){
//        _sendOrderZhidingSenctionFootView = [SendOrderZhidingSenctionFootView sendOrderZhidingSenctionFootView];
//        _sendOrderZhidingSenctionFootView.priceLab.hidden = YES;;
//        _sendOrderZhidingSenctionFootView.priceLab.text = [NSString stringWithFormat:@"价格: ¥%@/天",@(_showaddbillModel.top_price)];
//        _sendOrderZhidingSenctionFootView.timeLab.hidden = YES;
//        _sendOrderZhidingSenctionFootView.contentLab.hidden = YES;
//        return _sendOrderZhidingSenctionFootView;
//    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
     
    if(section ==0){
        return 40;
    }
    return 0.001f;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}


-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
