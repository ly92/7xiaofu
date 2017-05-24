//
//  EditAdressController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EditAdressController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "EditAdressCell.h"
#import "EditAdressMarkCell.h"
#import "EditAdressFooterView.h"
#import "BlockUIAlertView.h"
#import "ChooseAreViewController.h"
#import "NSString+Utils.h"
#import "ChooseArea3ViewController.h"

@interface EditAdressController ()
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (copy, nonatomic)  NSString *username;
@property (copy, nonatomic)  NSString *phone;
@property (copy, nonatomic)  NSString *prov_id;
@property (copy, nonatomic)  NSString *city_id;
@property (copy, nonatomic)  NSString *area_id;
@property (copy, nonatomic)  NSString *area_info;
@property (copy, nonatomic)  NSString *adress;

@end

@implementation EditAdressController

- (void)viewDidLoad {
    [super viewDidLoad];
//    @property (copy,nonatomic)NSString * address;
//    @property (copy,nonatomic)NSString * area_info;
//    @property (copy,nonatomic)NSString * area_id;
//    @property (copy,nonatomic)NSString * city_id;
//    @property (copy,nonatomic)NSString * true_name;
//    @property (copy,nonatomic)NSString * address_id;
//    @property (copy,nonatomic)NSString * mob_phone;
//    @property (assign,nonatomic)NSInteger  is_default;
//    @property (copy,nonatomic)NSString * prov_id;
    
    if (_isEdit ==  1) {
        
        self.navigationItem.title = @"添加新地址";


    }else{
        
        self.navigationItem.title = @"编辑";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"删除" titleColor:kThemeColor target:self action:@selector(deleateItemAction:)];
        
        _username = _adressModel.true_name;
        _phone = _adressModel.mob_phone;
        _area_info = _adressModel.area_info;
        _adress = _adressModel.address;
        
        
     }
    
    [_tableView registerNib:[UINib nibWithNibName:@"EditAdressCell" bundle:nil] forCellReuseIdentifier:@"EditAdressCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"EditAdressMarkCell" bundle:nil] forCellReuseIdentifier:@"EditAdressMarkCell"];

    
    UIView * foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 165)];
     EditAdressFooterView * footterView = [EditAdressFooterView editAdressFooterView];
    footterView.frame = CGRectMake(0, 0, kScreenWidth, 165);
    [foot addSubview:footterView];
    _tableView.tableFooterView =foot;
    
    [footterView.saveBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
       
        
        [self paramsVerify];
        
        
    }];
    
}

#pragma mark - 添加新地址
- (void)addAdressWithParams:(NSMutableDictionary *)params{

    
    [self showLoading];
    
    
    [MCNetTool postWithCacheUrl:HttpAddAdress params:params success:^(NSDictionary *requestDic, NSString *msg) {
      
        
        [self dismissLoading];

        
        [self showSuccessText:msg];

        if (_editAdressBlock) {
            _editAdressBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];

    }];
    
}
#pragma mark - 编辑新地址

- (void)editAdressWithParams:(NSMutableDictionary *)params{
    
    [self showLoading];

    [MCNetTool postWithCacheUrl:HttpEditAdress params:params success:^(NSDictionary *requestDic, NSString *msg) {
      
        [self dismissLoading];
        
        [self showSuccessText:msg];
        
        if (_editAdressBlock) {
            _editAdressBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];

    } fail:^(NSString *error) {
        [self showErrorText:error];

    }];

    
}

#pragma mark - 删除新地址
- (void)deleteAdress{
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"address_id"] = _adressModel.address_id;
    
    [MCNetTool postWithCacheUrl:HttpDelAdress params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self showSuccessText:msg];
        
        
        if (_editAdressBlock) {
            _editAdressBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
    }];
    
    
}



- (void)deleateItemAction:(UIBarButtonItem *)item{
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除收货地址吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 1){
           
        
            [self deleteAdress];
            
        }
        
    } otherButtonTitles:@"删除"];
    [alert show];

    
}

//@property (copy, nonatomic)  NSString *area;
//@property (copy, nonatomic)  NSString *adress


/**
 提交请求
 */
- (void)paramsVerify{

    if (_username.length ==0) {
        [self showErrorText:@"请输入姓名"];
        return;
    }
    if (![_phone isMobelphone]) {
        [self showErrorText:@"请输入正确的手机号码"];
        return;
    }
    if (_area_info.length ==0) {
        [self showErrorText:@"请选择地区"];
        return;
    }
    if (_adress.length == 0) {
        [self showErrorText:@"请输入详细地址"];
        return;
    }

    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"true_name"] = _username;
    params[@"mob_phone"] = _phone;
    params[@"address"] = _adress;
    params[@"prov_id"] = _prov_id;
    params[@"city_id"] = _city_id;
    params[@"area_id"] = _area_id;
    params[@"area_info"] = _area_info;
    
    if (_isEdit == 2) {
        params[@"address_id"] = _adressModel.address_id;
        [self editAdressWithParams:params];
        
    }else{
        [self addAdressWithParams:params];
    }

    
}



#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
         EditAdressCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EditAdressCell"];
         if (indexPath.row == 0) {
             cell.titleLab.text = @"姓名";
             cell.textField.placeholder = @"请输入收货人姓名";
             cell.textField.text = _adressModel.true_name;
             cell.editAdressCellBlock = ^(NSString  * content,BOOL pass){
             
                 _username = content;
             };
             
         }
         if (indexPath.row == 1) {
             cell.titleLab.text = @"手机号码";
             cell.textField.keyboardType =UIKeyboardTypeNumberPad;
             cell.textField.placeholder = @"请输入收货人手机号码";
             cell.textField.text = _adressModel.mob_phone;
             cell.editAdressCellBlock = ^(NSString  * content,BOOL pass){
                 _phone = content;
             };
             

         }
        return cell;
    }
     if (indexPath.section == 1) {
          if (indexPath.row == 0) {
             EditAdressCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EditAdressCell"];
              cell.titleLab.text = @"所在地区";
              cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
              cell.textField.enabled =NO;
              cell.textField.placeholder =@"请输入所在地区";
              cell.textField.text = _adressModel.area_info;

              return cell;
         }
        EditAdressMarkCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EditAdressMarkCell"];
         cell.textView.text = _adressModel.address;
         cell.editAdressMarkCellBlock = ^(NSString * content){
              _adress = content;
         };
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  50;
     }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
             return  50;
        }
     }
    return  80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row ==0) {

            
            ChooseArea3ViewController * vc = [[ChooseArea3ViewController alloc]initWithNibName:@"ChooseArea3ViewController" bundle:nil];
            
            vc.chooseArea3ViewBlock =^(AreasModel * areasModelProvince,AreasModel * areasModelCity,AreasModel * areasModelDis){
            
                EditAdressCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.textField.text = [NSString stringWithFormat:@"%@%@%@",areasModelProvince.area_name,areasModelCity.area_name,areasModelDis.area_name];

                _prov_id =areasModelProvince.area_id;
                _city_id =areasModelCity.area_id;
                _area_id =areasModelDis.area_id;
                _area_info =[NSString stringWithFormat:@"%@%@%@",areasModelProvince.area_name,areasModelCity.area_name,areasModelDis.area_name];
                
            };
            
            [self.navigationController pushViewController:vc animated:YES];
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
