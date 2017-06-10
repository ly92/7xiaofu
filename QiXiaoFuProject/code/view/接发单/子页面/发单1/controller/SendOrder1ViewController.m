//
//  SendOrder1ViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SendOrder1ViewController.h"
#import "SendOrderFooterView.h"
#import "SendOrder1Cell.h"
#import "SendOrderSwitchCell.h"
#import "SendOrderZhidingSenctionFootView.h"
#import "SendOrder1UpImageCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "PayViewController.h"
#import "NSArray+Utils.h"

@interface SendOrder1ViewController (){

    BOOL _isTop;
 

}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, strong) NSMutableArray *quyuArray;

@property (nonatomic, strong) SendOrderZhidingSenctionFootView * sendOrderZhidingSenctionFootView;

@end

@implementation SendOrder1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isFeedBack){
    self.navigationItem.title = @"意见反馈";
    }else{
    self.navigationItem.title = @"发单";
    }
    
    _quyuArray = [NSMutableArray new];
    [_quyuArray addObject:@"0"];
    [_quyuArray addObject:@"1"];
    if (!self.isFeedBack){
    [_quyuArray addObject:@"2"];
    }
    

    _isTop = NO;
    
    SendOrderFooterView * sendOrderFooterView = [SendOrderFooterView sendOrderFooterView];
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    [footerView addSubview:sendOrderFooterView];
    sendOrderFooterView.frame = footerView.bounds;
    _tableView.tableFooterView = footerView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrder1Cell" bundle:nil] forCellReuseIdentifier:@"SendOrder1Cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderSwitchCell" bundle:nil] forCellReuseIdentifier:@"SendOrderSwitchCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrder1UpImageCell" bundle:nil] forCellReuseIdentifier:@"SendOrder1UpImageCell"];

    if (self.isFeedBack){
    [sendOrderFooterView.trueSendOrderBtn setTitle:@"提交" forState:UIControlStateNormal];
    }else{
        [sendOrderFooterView.trueSendOrderBtn setTitle:@"确认发单" forState:UIControlStateNormal];
    }
    
    [sendOrderFooterView.trueSendOrderBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
       
        if (self.isFeedBack){
            NSString *content = _requestParams[@"bill_desc"];
            if (!content.yw_notNull){
                [self showErrorText:@"请输入反馈内容"];
                return ;
            }
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"content"] = content;
            params[@"member_name"] = kUserName;
            params[@"id"] = kUserId;
            params[@"userid"] = kUserId;
            
            [MCNetTool postWithUrl:HttpMeFeedBack params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:@"提交成功，感谢您的反馈！"];
                [self.navigationController popViewControllerAnimated:YES];
            } fail:^(NSString *error) {
                [self showErrorText:@"提交失败，请重试！"];
            }];
        }else{
            if (_isTop &&  [_requestParams[@"top_day"] length]==0) {
                [self showErrorText:@"请填写置顶天数"];
                return ;
            }
            PayViewController * vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
            vc.requestParams = _requestParams;
            vc.showaddbillModel = _showaddbillModel;
            vc.isTop = _isTop;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_tableView addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    [self.view endEditing:YES];

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
        if (self.isFeedBack){
        cell.textView.placeholder = @"请输入反馈内容";
        }else{
        cell.textView.placeholder = @"请输入备注内容";
        }
        
        cell.textView.completionBlock =^(NSString * text){
            _requestParams[@"bill_desc"] = text;//备注
        };
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        SendOrder1UpImageCell *   cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrder1UpImageCell"];
        cell.type =1;

        cell.sendOrder1UpImageCellBlock = ^(NSMutableArray * imageArray){
        
            LxDBAnyVar(imageArray);
            _requestParams[@"images"] = [imageArray string];//图片一维数组【 通过通过接口上传图片接口获取到的URL 】
        
        };
        return cell;
        
    }
    
    if (indexPath.row ==2) {
        SendOrderSwitchCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderSwitchCell"];
        cell.titleLab.text =@"置顶显示";
        cell.textField.hidden = YES;
        cell.zhidingSwitch.hidden = NO;
        cell.zhidingSwitch.on = NO;

        cell.zhidingSwitchBlock =^(BOOL on){
        
             _isTop = on;
            
            if (on) {
                
                _sendOrderZhidingSenctionFootView.priceLab.hidden = NO;;
                _sendOrderZhidingSenctionFootView.timeLab.hidden = YES;
                
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_quyuArray.count inSection:0];

                
                [indexPaths addObject: indexPath];
                [_quyuArray addObject:@"3"];
                
                //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                
            }else{
                _sendOrderZhidingSenctionFootView.priceLab.hidden = YES;;
                _sendOrderZhidingSenctionFootView.timeLab.hidden = YES;
                
                [_quyuArray removeObject:@"3"];
                [_requestParams removeObjectForKey:@"top_day"];
//                _requestParams[@"top_day"]
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];

                //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];

            }
        
        };
        
         return cell;
    }
    if (indexPath.row ==3) {
        SendOrderSwitchCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderSwitchCell"];
        cell.titleLab.text =@"置顶天数";
        cell.zhidingSwitch.hidden = YES;
        cell.textField.hidden = NO;
        cell.textField.text = @"";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
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
    if(section ==0){
        _sendOrderZhidingSenctionFootView = [SendOrderZhidingSenctionFootView sendOrderZhidingSenctionFootView];
         _sendOrderZhidingSenctionFootView.priceLab.hidden = YES;;
        _sendOrderZhidingSenctionFootView.priceLab.text = [NSString stringWithFormat:@"价格: ¥%@/天",@(_showaddbillModel.top_price)];
        _sendOrderZhidingSenctionFootView.timeLab.hidden = YES;
        _sendOrderZhidingSenctionFootView.contentLab.hidden = YES;
        return _sendOrderZhidingSenctionFootView;
    }
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
