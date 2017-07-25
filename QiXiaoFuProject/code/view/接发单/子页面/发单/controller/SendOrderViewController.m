//
//  SendOrderViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SendOrderViewController.h"
#import "ZHPickView.h"
#import "SendOrderCell.h"
#import "SendOrderDuoCell.h"
#import "SendOrderSwitchCell.h"
#import "SendOrderNumberCell.h"
#import "SendOrderProjectNameCell.h"
#import "ChooseSeviceDomainViewController.h"
#import "ChooseMapViewController.h"
#import "User.h"
#import "NSArray+Utils.h"
#import "SendOrder1ViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "SendOrderZhidingSenctionFootView.h"
#import "STPickerDate.h"
#import "ShowaddbillModel.h"
#import "ChooseSeviceDomainViewController.h"
#import "ChooseBrandViewController.h"
#import "LocalData.h"
#import "BlockUIAlertView.h"

#define SHAddressPickerViewHeight 216

@interface SendOrderViewController (){

    NSArray * _selectedDomainsIds;// 已选择的服务领域
    
    NSString * _service_sectorTitle;
    NSString * _service_formTitle;


}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (strong, nonatomic) NSArray *titles;
@property(nonatomic,strong)ZHPickView *pickview;

@property (nonatomic, strong) ShowaddbillModel *showaddbillModel;
@property (nonatomic, strong) NSMutableArray  *service_form;
@property (nonatomic, strong) NSMutableArray *service_sector;
@property (nonatomic, strong) NSMutableArray *service_type;


@property (nonatomic, strong) NSMutableDictionary * requestParams;// 客户发单请求参数


@end

@implementation SendOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发单";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"下一步" target:self action:@selector(nextItemAction:)];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    //    @[@"服务形式",@"服务类型",@"服务区域",@"服务时间",@"服务领域",@"品牌型号",@"其他服务领域",@"其他品牌型号",@"备注",@"服务价格",@"置顶显示",@"置顶天数"];
    
    _titles = @[@[@"项目名称",@"服务形式",@"服务类型",@"服务区域",@"预约开始时间",@"预约结束时间"],
              @[@"服务领域",@"品牌型号",@"数量/单位"],
//              @[@"其他服务领域(选填)"],
              @[@"服务价格"]];
    
    
  
    _requestParams= [NSMutableDictionary new];

    // 必选项
    _requestParams = [NSMutableDictionary dictionaryWithDictionary:[LocalData getSendTaskData]];
    _requestParams[@"userid"] = kUserId;//用户ID
//    _requestParams[@"title"] = value;//标题【服务领域 - 服务品牌 - 服务型号】
//*    _requestParams[@"service_sector"] = <#value#>;//服务领域ID
    
//*    _requestParams[@"service_brand"] = <#value#>;//服务品牌ID
//    _requestParams[@"service_mod"] = <#value#>;//ng	服务型号ID
    
    
//    _requestParams[@"other_service_sector"] = <#value#>;//	其他服务领域ID
    
//    _requestParams[@"other_service_brand"] = <#value#>;//其他服务品牌ID
//    _requestParams[@"other_service_mod"] = <#value#>;//其他服务型号ID
    
    
//*    _requestParams[@"service_form"] = value;//服务形式ID
//*    _requestParams[@"service_type"] = <#value#>;//服务类型ID
//*    _requestParams[@"service_city"] = <#value#>;//服务区域城市名
//*    _requestParams[@"service_address"] = <#value#>;//g	服务区域详细地址
//*    _requestParams[@"lng"] = <#value#>;//服务区域经度
//*    _requestParams[@"lat"] = <#value#>;//服务区域纬度
//*    _requestParams[@"service_tsime"] = <#value#>;//服务预约开始时间【时间戳】
//*    _requestParams[@"service_etime"] = <#value#>;//服务预约结束时间【时间戳】
    
    
    
//*    _requestParams[@"number"] = <#value#>;//数量
//*    _requestParams[@"number_unit"] = <#value#>;//数量单位

//*    _requestParams[@"service_price"] = <#value#>;//服务价格
    
    
//    _requestParams[@"payment_id"] = <#value#>;//支付方式ID 【0 使用钱包全额支付 2 支付宝支付 6微信支付】
//    _requestParams[@"is_wallet"] = <#value#>;//是否使用钱包【0 未使用 1 使用】
   
//    // 非必选项(返单第二步)
//    _requestParams[@"wallet_price"] = value;//使用钱包的金额
//*    _requestParams[@"top_day"] = <#value#>;//置顶天数
//*    _requestParams[@"bill_desc"] = <#value#>;//备注
//*    _requestParams[@"images"] = <#value#>;//图片一维数组【 通过通过接口上传图片接口获取到的URL 】
//    _requestParams[@"member_paypwd"] = <#value#>;//支付密码【MD5加密后】
//    _requestParams[@"is_compe"] = <#value#>;//是否为补单【0 否 1 是】

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;  //  随便设个不那么离谱的值
    
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderCell" bundle:nil] forCellReuseIdentifier:@"SendOrderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderDuoCell" bundle:nil] forCellReuseIdentifier:@"SendOrderDuoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderSwitchCell" bundle:nil] forCellReuseIdentifier:@"SendOrderSwitchCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderNumberCell" bundle:nil] forCellReuseIdentifier:@"SendOrderNumberCell"];
    [_tableView registerClass:[SendOrderProjectNameCell class] forCellReuseIdentifier:NSStringFromClass([SendOrderProjectNameCell class])];

    [self showaddbillData];
    
    // Do any additional setup after loadinwg the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveSendTask) name:@"sendTaskNotificationname" object:nil];
}

- (void)saveSendTask{
    if (_requestParams.allKeys.count > 1){
        [LocalData saveSendTaskData:_requestParams];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendTaskNotificationname" object:nil];
}

- (void)backClick
{
    if (_requestParams.allKeys.count > 1){
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"是否需要保存数据" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                [LocalData saveSendTaskData:_requestParams];
            }else{
                [LocalData removeSendTaskData];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } otherButtonTitles:@"确定"];
        [alert show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark - 客户发单的必要信息
- (void)showaddbillData{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
 
    [MCNetTool postWithCacheUrl:HttpMainShowaddbill params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _showaddbillModel = [ShowaddbillModel mj_objectWithKeyValues:requestDic];
        
        _service_form = [NSMutableArray new];
        _service_sector = [NSMutableArray new];
        _service_type = [NSMutableArray new];
        
        [_showaddbillModel.service_form enumerateObjectsUsingBlock:^(Service_Form * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_service_form addObject:obj.field_name];
        }];
        [_showaddbillModel.service_sector enumerateObjectsUsingBlock:^(Service_Sector12 * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [_service_sector addObject:obj.gc_name];
        }];
          [_showaddbillModel.service_type enumerateObjectsUsingBlock:^(Service_Type * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_service_type addObject:obj.field_name];
        }];
        
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        
    }];


}

#pragma mark - 下一步
- (void)nextItemAction:(UIBarButtonItem *)item{
    
    if ([_requestParams[@"project_name"] length] == 0) {
        [self showErrorText:@"请填写项目名称"];
        return;
    }
    if ([_requestParams[@"service_form"] length] == 0) {
        [self showErrorText:@"请选择服务形式"];
        return;
    }
    if ([_requestParams[@"service_type"] length] == 0) {
        [self showErrorText:@"请选择服务类型"];
        return;
    }
    if ([_requestParams[@"service_address"] length] == 0) {
        [self showErrorText:@"请选择服务区域"];
        return;
    }
    if ([_requestParams[@"lng"]  isEqual: @(0)]  || [_requestParams[@"lat"]  isEqual: @(0)]) {
        [self showErrorText:@"请重新选择服务区域"];
        return;
    }
    
    if ([_requestParams[@"service_stime"] length] == 0) {
        [self showErrorText:@"请选择服务开始时间"];
        return;
    }
    if ([_requestParams[@"service_etime"] length] == 0) {
        [self showErrorText:@"请选择服务结束时间"];
        return;
    }
    
    NSString * service_stime = _requestParams[@"service_stime"];
    NSString * service_etime = _requestParams[@"service_etime"];
    
    if([service_stime integerValue] > [service_etime integerValue]){
    
        [self showErrorText:@"服务结束时间不能早于服务开始时间"];
        return;
    }
    
    if ([_requestParams[@"service_sector"] length] == 0) {
        [self showErrorText:@"请选择服务领域"];
        return;
    }
    if ([_requestParams[@"service_brand"] length] == 0) {
        [self showErrorText:@"请填写品牌型号"];
        return;
    }
    if ([_requestParams[@"number"] length] == 0) {
        [self showErrorText:@"请填写服务数量"];
        return;
    }
    if ([_requestParams[@"number_unit"] length] == 0) {
        [self showErrorText:@"请填写服务数量单位"];
        return;
    }
    if ([_requestParams[@"service_price"] length] == 0) {
        [self showErrorText:@"请填写服务价格"];
        return;
    }
    if ([_requestParams[@"service_price"] floatValue] == 0) {
        [self showErrorText:@"服务价格不能为0"];
        return;
    }
    
    _requestParams[@"title"] = [NSString stringWithFormat:@"%@-%@",_service_sectorTitle,_requestParams[@"service_brand"]];//标题【服务领域 - 服务品牌 - 服务型号】
    
//    _requestParams[@"title"] = [NSString stringWithFormat:@"%@-%@",_service_sectorTitle,_service_formTitle];//标题【服务领域 - 服务品牌 - 服务型号】

    
    SendOrder1ViewController * vc = [[SendOrder1ViewController alloc]initWithNibName:@"SendOrder1ViewController" bundle:nil ];
    vc.requestParams = _requestParams;
    vc.showaddbillModel = _showaddbillModel;
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
    
    NSDictionary *localDict = [LocalData getSendTaskData];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SendOrderProjectNameCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendOrderProjectNameCell class])];
            
            cell.projectNameLabel.text=_titles[indexPath.section][indexPath.row];
            
            [cell setTextFieldBlock:^(NSString *text) {//输入框输入文本
                _requestParams[@"project_name"] = text;//服务价格
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([localDict.allKeys containsObject:@"project_name"]){
                cell.projectNameTextField.text = [localDict objectForKey:@"project_name"];
            }
            return cell;
        }
        SendOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderCell"];
        cell.titleLab.text =_titles[indexPath.section][indexPath.row];
        if (indexPath.row == 1) {// 服务形式
            if ([localDict.allKeys containsObject:@"service_form"]){
                NSString *value = [localDict objectForKey:@"service_form"];
                for (Service_Form * service_form in _showaddbillModel.service_form) {
                    if ([service_form.field_value isEqualToString:value]){
                    cell.descLab.text = service_form.field_name;
                    }
                }
            }
        }
        if (indexPath.row ==2) {// 服务类型
            if ([localDict.allKeys containsObject:@"service_type"]){
                NSString *value = [localDict objectForKey:@"service_type"];
                for (Service_Type * service_type in _showaddbillModel.service_type) {
                    if ([service_type.field_value isEqualToString:value]){
                        cell.descLab.text = service_type.field_name;
                    }
                }
            }
        }
        if (indexPath.row ==3) {// 服务区域
            if ([localDict.allKeys containsObject:@"service_address"] && [localDict.allKeys containsObject:@"lng"] && [localDict.allKeys containsObject:@"lat"]){
                cell.descLab.text = [localDict objectForKey:@"service_address"];
            }
        }
        if (indexPath.row ==4) {// 预约开始时间
            if ([localDict.allKeys containsObject:@"service_stime"]){
                cell.descLab.text = [Utool timeStamp3TimeFormatter:[localDict objectForKey:@"service_stime"]];
            }
        }
        if (indexPath.row ==5) {// 预约结束时间
            if ([localDict.allKeys containsObject:@"service_etime"]){
                cell.descLab.text = [Utool timeStamp3TimeFormatter:[localDict objectForKey:@"service_etime"]];
            }
        }
        
        //        cell.descLab.text =@"俺舍不得分哈哈是否家的饭还是骄傲的回复啥地方哈哈啥地方哈师大阿斯顿和发挥巨大师傅好骄傲是";
        return cell;
    }
    if (indexPath.section ==1) {
        if (indexPath.row == 0 ) {
            
            SendOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderCell"];
            cell.titleLab.text =_titles[indexPath.section][indexPath.row];
            if ([localDict.allKeys containsObject:@"service_sector"]){
                NSString *str1 = [localDict objectForKey:@"service_sector"];
                NSArray *ids = [str1 componentsSeparatedByString:@","];
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSString *str2 in ids) {
                    for (Service_Sector12 *user in _showaddbillModel.service_sector) {
                        if ([user.gc_id isEqualToString:str2]){
                            [arrM addObject:user.gc_name];
                        }
                    }
                }
                cell.descLab.text = [arrM componentsJoinedByString:@","];
            }
            return cell;
        }
        if (indexPath.row == 1) {
            
            SendOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderCell"];
            cell.titleLab.text =_titles[indexPath.section][indexPath.row];
            if ([localDict.allKeys containsObject:@"service_brand"]){
                cell.descLab.text = [localDict objectForKey:@"service_brand"];
            }
            return cell;
        }
        if (indexPath.row ==2) {
            SendOrderNumberCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderNumberCell"];
            cell.titleLab.text =_titles[indexPath.section][indexPath.row];
            if ([localDict.allKeys containsObject:@"number"]){
                cell.numTextField.text = [localDict objectForKey:@"number"];
            }
            if ([localDict.allKeys containsObject:@"number_unit"]){
                cell.textField.text = [localDict objectForKey:@"number_unit"];
            }
            cell.numTextFieldBlock = ^(NSString * number){
                _requestParams[@"number"] = number;//数量
            };
            cell.textFieldBlock = ^(NSString * text){
                _requestParams[@"number_unit"] = text;//数量单位
            };
            return cell;
        }
    }
//    if (indexPath.section ==2) {
//        SendOrderDuoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderDuoCell"];
//        cell.titleLab.text =_titles[indexPath.section][indexPath.row];
//        return cell;
//        
//    }
    if (indexPath.section ==2) {
        SendOrderSwitchCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SendOrderSwitchCell"];
        cell.titleLab.text =_titles[indexPath.section][indexPath.row];
        cell.zhidingSwitch.hidden = YES;
        cell.textField.placeholder = @"请输入价格";
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        if ([localDict.allKeys containsObject:@"service_price"]){
            cell.textField.text = [localDict objectForKey:@"service_price"];
        }
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
    if(indexPath.section == 2){
         return 44;
     }
     return UITableViewAutomaticDimension;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (![MCNetTool net]) {
        
        [self showErrorText:@"请检查网络"];
        
        return;
    }
    
    
    
    
    WEAKSELF
    
    if (indexPath.section == 0) {
        
        SendOrderCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (indexPath.row == 1) {// 服务形式
             _pickview = [self pickview];;
             [self addPikerViewWithArray:_service_form withTag:1];
            _pickview.completionPickView=^(NSString *resultString,NSInteger row,NSInteger tag){
                
                cell.descLab.text =resultString;
                Service_Form * service_form =weakSelf.showaddbillModel.service_form[row];
                weakSelf.requestParams[@"service_form"] = service_form.field_value;//服务形式ID
                _service_formTitle = resultString;
             };
            
        }
        if (indexPath.row ==2) {// 服务类型
            _pickview = [self pickview];;
            [self addPikerViewWithArray:_service_type withTag:2];
            _pickview.completionPickView=^(NSString *resultString,NSInteger row,NSInteger tag){
                
                cell.descLab.text =resultString;
                Service_Type * service_type =weakSelf.showaddbillModel.service_type[row];
                weakSelf.requestParams[@"service_type"] = service_type.field_value;//服务类型ID
                
            };
        }
        if (indexPath.row ==3) {// 服务区域
          
               // 选择服务区域
//            ChooseSeviceAreaViewController * vc = [[ChooseSeviceAreaViewController alloc]initWithNibName:@"ChooseSeviceAreaViewController" bundle:nil];
            
            ChooseMapViewController * vc = [[ChooseMapViewController alloc]initWithNibName:@"ChooseMapViewController" bundle:nil];
            
                         vc.chooseSeviceAreaBlock =^(AMapTip * selectPoi){
                
                cell.descLab.text =selectPoi.name;

//                _requestParams[@"service_city"] = [selectPoi.name stringByReplacingOccurrencesOfString:@"市" withString:@""]  ;//服务区域城市名
                _requestParams[@"service_address"] = [NSString stringWithFormat:@"%@",selectPoi.name];//g	服务区域详细地址
                
                if (selectPoi.location.longitude == 0 || selectPoi.location.latitude == 0){
                    [self showErrorText:@"所选服务区域不可用"];
                }
                _requestParams[@"lng"] = @(selectPoi.location.longitude);//服务区域经度
                _requestParams[@"lat"] = @(selectPoi.location.latitude);//服务区域纬度
                
              };
            [self.navigationController pushViewController:vc animated:YES];
            
         }
        if (indexPath.row ==4) {// 预约开始时间
            
            STPickerDate *pickerDate = [[STPickerDate alloc]initWithRow:4];
            pickerDate.pickerDate5Block = ^(NSInteger year,NSInteger month,NSInteger day,NSInteger hour,NSInteger minute,NSString * time){
                cell.descLab.text =[NSString stringWithFormat:@"%ld年%ld月%ld日 %ld时",year,month,day,hour];
                _requestParams[@"service_stime"] = [Utool timestampForDateFromString:time withFormat:@"yyyy.MM.dd HH:mm"];//服务预约开始时间【时间戳】
            };
            [pickerDate show];
            
        }
        if (indexPath.row ==5) {// 预约结束时间
            
            STPickerDate *pickerDate = [[STPickerDate alloc]initWithRow:4];
            pickerDate.pickerDate5Block = ^(NSInteger year,NSInteger month,NSInteger day,NSInteger hour,NSInteger minute,NSString * time){
                cell.descLab.text =[NSString stringWithFormat:@"%ld年%ld月%ld日 %ld时",year,month,day,hour];
                _requestParams[@"service_etime"] = [Utool timestampForDateFromString:time withFormat:@"yyyy.MM.dd HH:mm"];//服务预约结束时间【时间戳】
                
            };
            [pickerDate show];
            
        }
  
    }
    if (indexPath.section == 1) {

        if (indexPath.row == 0) {
            // 选择服务领域
             ChooseSeviceDomainViewController * vc = [[ChooseSeviceDomainViewController alloc]initWithNibName:@"ChooseSeviceDomainViewController" bundle:nil];
            vc.allowsMultipleSelection = YES;
            vc.domains =_showaddbillModel.service_sector;
            vc.selectedContactIds = [self contactIdsForContacts:_selectedDomainsIds];
            vc.domainsChooseSeviceDomainViewBlock = ^(NSArray * somains){
                
                SendOrderCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                LxDBAnyVar(somains);
                _selectedDomainsIds =somains;
                
                NSMutableArray * titles = [NSMutableArray new];
                NSMutableArray * ids = [NSMutableArray new];

                [somains enumerateObjectsUsingBlock:^( Service_Sector12 *  user , NSUInteger idx, BOOL * _Nonnull stop) {
                    [titles addObject:user.gc_name];
                    [ids addObject:user.gc_id];
                }];
                NSString * titleStr = [titles string];
                cell.descLab.text = titleStr;
                
                _requestParams[@"service_sector"] = [ids string] ;//服务领域ID
                _service_sectorTitle =titleStr;
                
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 1){
        
        
            ChooseBrandViewController * vc = [[ChooseBrandViewController alloc]initWithNibName:@"ChooseBrandViewController" bundle:nil];
            vc.chooseBrandViewBlock = ^(NSString * text){
                 SendOrderCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.descLab.text = text;
                
                _requestParams[@"service_brand"] = text;//服务品牌ID
                
              };
            [self.navigationController pushViewController:vc animated:YES];

        }
        
    }
//    if (indexPath.section == 2) {
//        
//        //其他服务领域(选填)
//            ChooseSeviceDomainViewController * vc = [[ChooseSeviceDomainViewController alloc]initWithNibName:@"ChooseSeviceDomainViewController" bundle:nil];
//            vc.allowsMultipleSelection = YES;
//            vc.domains =_showaddbillModel.service_sector;
//
//            //vc.selectedContactIds = [self contactIdsForContacts:_selectedDomainsIds];
//            
//            vc.domainsChooseSeviceDomainViewBlock = ^(NSArray * somains){
//                
//                SendOrderDuoCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//                LxDBAnyVar(somains);
//                _selectedDomainsIds =somains;
//                
//                NSMutableArray * titles = [NSMutableArray new];
//                NSMutableArray * ids = [NSMutableArray new];
//
//                [somains enumerateObjectsUsingBlock:^( Service_Sector12 *  user , NSUInteger idx, BOOL * _Nonnull stop) {
//                    [titles addObject:user.gc_name];
//                    [ids addObject:user.gc_id];
//                 }];
//                NSString * titleStr = [titles string];
//                cell.descLab.text = titleStr;
//                 _requestParams[@"other_service_sector"] = [ids string];//	其他服务领域ID
//                
//            };
//            [self.navigationController pushViewController:vc animated:YES];
//        }
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
    if(section ==2){
        SendOrderZhidingSenctionFootView * sendOrderZhidingSenctionFootView = [SendOrderZhidingSenctionFootView sendOrderZhidingSenctionFootView];
        
        sendOrderZhidingSenctionFootView.contentLab.text =[NSString stringWithFormat:@"%@",_showaddbillModel.reference];

//        sendOrderZhidingSenctionFootView.contentLab.text = @"参考价格,初级¥500-1000;中级¥1000-1500;高级¥1500-2000;";
        sendOrderZhidingSenctionFootView.timeLab.hidden = YES;
        sendOrderZhidingSenctionFootView.priceLab.hidden = YES;

        return sendOrderZhidingSenctionFootView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section ==2){
        return 50;
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
