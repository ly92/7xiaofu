//
//  ChongSendOrderVC1.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChongSendOrderVC1.h"
#import "ZHPickView.h"
#import "SendOrderCell.h"
#import "SendOrderDuoCell.h"
#import "SendOrderSwitchCell.h"
#import "SendOrderNumberCell.h"
#import "ChooseSeviceDomainViewController.h"
#import "ChooseMapViewController.h"
#import "User.h"
#import "NSArray+Utils.h"
#import "ChongSendOrderVC2.h"
#import "TPKeyboardAvoidingTableView.h"
#import "SendOrderZhidingSenctionFootView.h"
#import "STPickerDate.h"
#import "ChooseSeviceDomainViewController.h"
#import "ChooseBrandViewController.h"
#import "ChongSendOrderModel.h"



#define SHAddressPickerViewHeight 216
@interface ChongSendOrderVC1 (){
    
    NSArray * _selectedDomainsIds;// 已选择的服务领域
    
}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@property (strong, nonatomic) NSArray *titles;
@property(nonatomic,strong)ZHPickView *pickview;
@property (nonatomic, strong) NSMutableArray  *service_form;
@property (nonatomic, strong) NSMutableArray *service_sector;
@property (nonatomic, strong) NSMutableArray *service_type;

@property (nonatomic, strong) ChongSendOrderModel *chongSendOrderModel;

@property (nonatomic, strong) NSMutableDictionary * requestParams;// 客户发单请求参数

@property (nonatomic, copy) NSString  *serviceXingshi;
@property (nonatomic, copy) NSString  *serviceLeixing;
@property (nonatomic, copy) NSString  *serviceQuyu;
@property (nonatomic, copy) NSString  *serviceKashiTime;
@property (nonatomic, copy) NSString  *serviceJieShuTime;
@property (nonatomic, copy) NSString  *serviceLingyu;





@end

@implementation ChongSendOrderVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发单";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"下一步" target:self action:@selector(nextItemAction:)];
    
    
    //    @[@"服务形式",@"服务类型",@"服务区域",@"服务时间",@"服务领域",@"品牌型号",@"其他服务领域",@"其他品牌型号",@"备注",@"服务价格",@"置顶显示",@"置顶天数"];
    
    _titles = @[@[@"服务形式",@"服务类型",@"服务区域",@"预约开始时间",@"预约结束时间"],
                @[@"服务领域",@"品牌型号",@"数量/单位"],
                @[@"其他服务领域(选填)"],
                @[@"服务价格"]];
    
    
    _service_form = [NSMutableArray new];
    _service_sector = [NSMutableArray new];
    _service_type = [NSMutableArray new];
    
    _requestParams= [NSMutableDictionary new];
    
    // 必选项
    _requestParams[@"userid"] = kUserId;//用户ID
    _requestParams[@"id"] = _f_id;

    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;  //  随便设个不那么离谱的值
    
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderCell" bundle:nil] forCellReuseIdentifier:@"SendOrderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderDuoCell" bundle:nil] forCellReuseIdentifier:@"SendOrderDuoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderSwitchCell" bundle:nil] forCellReuseIdentifier:@"SendOrderSwitchCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderNumberCell" bundle:nil] forCellReuseIdentifier:@"SendOrderNumberCell"];
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"id"] = _f_id;
    
    [MCNetTool postWithUrl:HttpMeShowReSetBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _chongSendOrderModel = [ChongSendOrderModel mj_objectWithKeyValues:requestDic];

//        _requestParams[@"service_price"] = _chongSendOrderModel.service_price;
        _requestParams[@"number"] = _chongSendOrderModel.number;
//        _requestParams[@"number_unit"] = _chongSendOrderModel.number_unit;

        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}






#pragma mark - 下一步
- (void)nextItemAction:(UIBarButtonItem *)item{
    
    
    
//    if ([_requestParams[@"service_form"] length] == 0) {
//        [self showErrorText:@"请选择服务形式"];
//        return;
//    }
//    if ([_requestParams[@"service_type"] length] == 0) {
//        [self showErrorText:@"请选择服务类型"];
//        return;
//    }
//    if ([_requestParams[@"service_city"] length] == 0) {
//        [self showErrorText:@"请选择服务区域"];
//        return;
//    }
    if ([_requestParams[@"service_stime"] length] == 0) {
        [self showErrorText:@"请选择服务开始时间"];
        return;
    }
    if ([_requestParams[@"service_etime"] length] == 0) {
        [self showErrorText:@"请选择服务结束时间"];
        return;
    }
//    if ([_requestParams[@"service_sector"] length] == 0) {
//        [self showErrorText:@"请选择服务领域"];
//        return;
//    }
//    if ([_requestParams[@"service_brand"] length] == 0) {
//        [self showErrorText:@"请选择服务品牌"];
//        return;
//    }
    if ([_requestParams[@"number"] length] == 0) {
        [self showErrorText:@"请填写服务数量"];
        return;
    }
//    if ([_requestParams[@"number_unit"] length] == 0) {
//        [self showErrorText:@"请填写服务数量单位"];
//        return;
//    }
//    if ([_requestParams[@"service_price"] length] == 0) {
//        [self showErrorText:@"请填写服务价格"];
//        return;
//    }
//    _requestParams[@"title"] = [NSString stringWithFormat:@"%@-%@",_requestParams[@"service_sector"],_requestParams[@"service_brand"]];//标题【服务领域 - 服务品牌 - 服务型号】
    
    ChongSendOrderVC2 * vc = [[ChongSendOrderVC2 alloc]initWithNibName:@"ChongSendOrderVC2" bundle:nil ];
    vc.requestParams = _requestParams;
    vc.chongSendOrderModel = _chongSendOrderModel;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SendOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderCell"];
        cell.titleLab.text =_titles[indexPath.section][indexPath.row];
        
        if (indexPath.row == 0) {
            cell.descLab.text = _chongSendOrderModel.service_form;
        }
        if (indexPath.row == 1) {
            cell.descLab.text = _chongSendOrderModel.service_type;
        }
        if (indexPath.row == 2) {
            cell.descLab.text = _chongSendOrderModel.service_address;
        }
        return cell;
    }
    if (indexPath.section ==1) {
        if (indexPath.row < 2 ) {
            
            SendOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderCell"];
            cell.titleLab.text =_titles[indexPath.section][indexPath.row];
            if(indexPath.row ==0){
                cell.descLab.text = _chongSendOrderModel.service_sector;
            }
            if(indexPath.row ==1){
                cell.descLab.text = _chongSendOrderModel.service_brand;
            }
            return cell;
        }
        if (indexPath.row ==2) {
            SendOrderNumberCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderNumberCell"];
            cell.titleLab.text =_titles[indexPath.section][indexPath.row];
            cell.numTextField.text =_chongSendOrderModel.number;
            cell.textField.text =_chongSendOrderModel.number_unit;
            cell.textField.userInteractionEnabled =NO;

            cell.numTextFieldBlock = ^(NSString * number){
                
                _requestParams[@"number"] = number;//数量
            };
//            cell.textFieldBlock = ^(NSString * text){
//                
//                _requestParams[@"number_unit"] = text;//数量单位
//                
//            };
            return cell;
        }
    }
    if (indexPath.section ==2) {
        SendOrderDuoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderDuoCell"];
        cell.titleLab.text =_titles[indexPath.section][indexPath.row];
        cell.descLab.text = _chongSendOrderModel.other_service_mod;

        return cell;
        
    }
    if (indexPath.section ==3) {
        SendOrderSwitchCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderSwitchCell"];
        cell.titleLab.text =_titles[indexPath.section][indexPath.row];
        cell.zhidingSwitch.hidden = YES;
        cell.textField.placeholder = @"请输入价格";
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.textField.text = _chongSendOrderModel.service_price;
        cell.textField.userInteractionEnabled = NO;

        cell.textFieldBlock =^(NSString * text){
            
            _requestParams[@"service_price"] = text;//服务价格
            
        };
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if (indexPath.row == 2) {
            return 44;
        }
        return UITableViewAutomaticDimension;
    }
    if(indexPath.section == 3){
        return 44;
    }
    return UITableViewAutomaticDimension;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
//    WEAKSELF
    
    if (indexPath.section == 0) {
//
        SendOrderCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//
//        if (indexPath.row == 0) {// 服务形式
//            _pickview = [self pickview];;
//            [self addPikerViewWithArray:_service_form withTag:1];
//            _pickview.completionPickView=^(NSString *resultString,NSInteger row,NSInteger tag){
//                
//                cell.descLab.text =resultString;
//                Service_Form * service_form =weakSelf.showaddbillModel.service_form[row];
//                weakSelf.requestParams[@"service_form"] = service_form.field_value;//服务形式ID
//            };
//            
//        }
//        if (indexPath.row ==1) {// 服务类型
//            _pickview = [self pickview];;
//            [self addPikerViewWithArray:_service_type withTag:2];
//            _pickview.completionPickView=^(NSString *resultString,NSInteger row,NSInteger tag){
//                
//                cell.descLab.text =resultString;
//                Service_Type * service_type =weakSelf.showaddbillModel.service_type[row];
//                weakSelf.requestParams[@"service_type"] = service_type.field_value;//服务类型ID
//                
//            };
//        }
//        if (indexPath.row ==2) {// 服务区域
//            
//            // 选择服务区域
//            //            ChooseSeviceAreaViewController * vc = [[ChooseSeviceAreaViewController alloc]initWithNibName:@"ChooseSeviceAreaViewController" bundle:nil];
//            
//            ChooseMapViewController * vc = [[ChooseMapViewController alloc]initWithNibName:@"ChooseMapViewController" bundle:nil];
//            
//            
//            vc.chooseSeviceAreaBlock =^(AMapPOI * selectPoi){
//                LxDBAnyVar(selectPoi.name);
//                
//                cell.descLab.text =selectPoi.name;
//                
//                _requestParams[@"service_city"] = selectPoi.name;//服务区域城市名
//                _requestParams[@"service_address"] = selectPoi.address;//g	服务区域详细地址
//                _requestParams[@"lng"] = @(selectPoi.location.longitude);//服务区域经度
//                _requestParams[@"lat"] = @(selectPoi.location.longitude);//服务区域纬度
//                
//                
//            };
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }
        if (indexPath.row ==3) {// 预约开始时间
            
            STPickerDate *pickerDate = [[STPickerDate alloc]initWithRow:3];
            pickerDate.pickerDate3Block = ^(NSInteger year,NSInteger month,NSInteger day,NSString * time){
                
                cell.descLab.text =[NSString stringWithFormat:@"%ld年%ld月%ld日",year,month,day];
                _requestParams[@"service_stime"] = [Utool timestampForDateFromString:time withFormat:@"yyyy.MM.dd HH:mm"];//服务预约开始时间【时间戳】
            };
            [pickerDate show];
            
            
        }
        if (indexPath.row ==4) {// 预约结束时间
            
            STPickerDate *pickerDate = [[STPickerDate alloc]initWithRow:3];
            pickerDate.pickerDate3EndBlock = ^(NSInteger year,NSInteger month,NSInteger day,NSString * time){
                cell.descLab.text =[NSString stringWithFormat:@"%ld年%ld月%ld日",year,month,day];
                _requestParams[@"service_etime"] = [Utool timestampForDateFromString:time withFormat:@"yyyy.MM.dd HH:mm"];//服务预约结束时间【时间戳】
            };
            [pickerDate show];
            
        }
        
    }
//    if (indexPath.section == 1) {
//        
//        if (indexPath.row == 0) {
//            // 选择服务领域
//            ChooseSeviceDomainViewController * vc = [[ChooseSeviceDomainViewController alloc]initWithNibName:@"ChooseSeviceDomainViewController" bundle:nil];
//            vc.allowsMultipleSelection = YES;
//            vc.domains =_showaddbillModel.service_sector;
//            
//            vc.selectedContactIds = [self contactIdsForContacts:_selectedDomainsIds];
//            
//            vc.domainsChooseSeviceDomainViewBlock = ^(NSArray * somains){
//                
//                SendOrderCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//                LxDBAnyVar(somains);
//                _selectedDomainsIds =somains;
//                
//                NSMutableArray * titles = [NSMutableArray new];
//                NSMutableArray * ids = [NSMutableArray new];
//                
//                [somains enumerateObjectsUsingBlock:^( Service_Sector12 *  user , NSUInteger idx, BOOL * _Nonnull stop) {
//                    [titles addObject:user.gc_name];
//                    [ids addObject:user.gc_id];
//                }];
//                NSString * titleStr = [titles string];
//                cell.descLab.text = titleStr;
//                
//                _requestParams[@"service_sector"] = [ids string] ;//服务领域ID
//                
//            };
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }else if (indexPath.row == 1){
//            
//            
//            ChooseBrandViewController * vc = [[ChooseBrandViewController alloc]initWithNibName:@"ChooseBrandViewController" bundle:nil];
//            vc.chooseBrandViewBlock = ^(NSString * text){
//                SendOrderCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//                cell.descLab.text = text;
//                
//                _requestParams[@"service_brand"] = text;//服务品牌ID
//                
//            };
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }
//        
//    }
//    if (indexPath.section == 2) {
//        
//        //其他服务领域(选填)
//        ChooseSeviceDomainViewController * vc = [[ChooseSeviceDomainViewController alloc]initWithNibName:@"ChooseSeviceDomainViewController" bundle:nil];
//        vc.allowsMultipleSelection = YES;
//        vc.domains =_showaddbillModel.service_sector;
//        
//        vc.selectedContactIds = [self contactIdsForContacts:_selectedDomainsIds];
//        
//        vc.domainsChooseSeviceDomainViewBlock = ^(NSArray * somains){
//            
//            SendOrderDuoCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//            LxDBAnyVar(somains);
//            _selectedDomainsIds =somains;
//            
//            NSMutableArray * titles = [NSMutableArray new];
//            NSMutableArray * ids = [NSMutableArray new];
//            
//            [somains enumerateObjectsUsingBlock:^( Service_Sector12 *  user , NSUInteger idx, BOOL * _Nonnull stop) {
//                [titles addObject:user.gc_name];
//                [ids addObject:user.gc_id];
//            }];
//            NSString * titleStr = [titles string];
//            cell.descLab.text = titleStr;
//            _requestParams[@"other_service_sector"] = [ids string];//	其他服务领域ID
//            
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}


/**
 *  处理已经选择的服务领域
 *
 *  @param contacts 已经选择的服务领域的数组
 *
 */
- (NSSet *)contactIdsForContacts:(NSArray *)contacts {
    NSMutableSet *contactIdSet = [NSMutableSet set];
    for (Service_Sector12 *contact in contacts) {
        [contactIdSet addObject:contact.gc_id];
    }
    return contactIdSet;
}


- (void)addPikerViewWithArray:(NSArray *)array withTag:(NSInteger )tag{
    [_pickview removeFromSuperview];
    _pickview = nil;
    if(!_pickview){
        _pickview=[[ZHPickView alloc] initPickviewWithArray:array];
        _pickview.tag = tag;
        [_pickview show:self];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if(section ==3){
//        SendOrderZhidingSenctionFootView * sendOrderZhidingSenctionFootView = [SendOrderZhidingSenctionFootView sendOrderZhidingSenctionFootView];
//        
////        sendOrderZhidingSenctionFootView.contentLab.text =[NSString stringWithFormat:@"%@",_showaddbillModel.reference];
//        
//        //        sendOrderZhidingSenctionFootView.contentLab.text = @"参考价格,初级¥500-1000;中级¥1000-1500;高级¥1500-2000;";
//        sendOrderZhidingSenctionFootView.timeLab.hidden = YES;
//        sendOrderZhidingSenctionFootView.priceLab.hidden = YES;
//        
//        return sendOrderZhidingSenctionFootView;
//    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section ==3){
        return 30;
    }
    return 0.001f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
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
