//
//  ReceivingOrderViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/28.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ReceivingOrderViewController.h"
#import "ReceivingOrderEditFooterView.h"
#import "ReceivingOrderEditSectionView.h"
#import "ChooseSeviceDomainViewController.h"
#import "ChooseMapViewController.h"
#import "User.h"
#import "NSArray+Utils.h"
#import "STPickerDate.h"
#import "ReceivingOrderShowModel.h"
#import "LocalData.h"


@interface ReceivingOrderViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSArray * _selectedDomainsIds;// 已选择的服务领域

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *titles;
@property (nonatomic, strong) ReceivingOrderEditSectionView * sectionFooterView;
@property (strong, nonatomic) NSMutableArray *quyuArray;

@property (nonatomic, copy) NSString  *service_stime;
@property (nonatomic, copy) NSString  *service_etime;

@property (nonatomic, strong) ShowaddbillModel * showaddbillModel;
//@property (nonatomic,copy)NSString * service_sectorStr;


@end

@implementation ReceivingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我要接单";
    
    [self setupData];
    
//    _titles = @[@"服务区域",@"服务领域",@"设置空闲开始时间",@"设置空闲结束时间"];
    _titles = @[@"服务区域",@"设置空闲开始时间",@"设置空闲结束时间"];
    
    if (self.quyuArray.count == 0){
        [_quyuArray addObject:@"   "];
    }

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SettingCell"];
    
    ReceivingOrderEditFooterView * receivingOrderEditFooterView = [ReceivingOrderEditFooterView receivingOrderEditFooterView];
     UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    [footerView addSubview:receivingOrderEditFooterView];
    receivingOrderEditFooterView.frame = footerView.bounds;
    _tableView.tableFooterView = footerView;

    [self showaddbillDataJ];
    
    [receivingOrderEditFooterView.fabuBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
       
        [self tackDataSave];
        
    }];

 
    // Do any additional setup after loading the view from its nib.
}

- (NSMutableArray *)quyuArray{
    if (!_quyuArray){
        _quyuArray = [NSMutableArray array];
    }
    return _quyuArray;
}

- (void)setupData{
    if ([self.titleStr yw_notNull]){
    self.navigationItem.title = self.titleStr;
        if ([self.spaceTimeModel yw_notNull]){
            
            [self.quyuArray removeAllObjects];
            [self.quyuArray addObjectsFromArray:self.spaceTimeModel.tack_arrays];
            self.service_stime = [Utool comment_timeStamp2TimeFormatter:self.spaceTimeModel.service_stime];
            self.service_etime = [Utool comment_timeStamp2TimeFormatter:self.spaceTimeModel.service_etime];
            
            [self.tableView reloadData];
        }
    }
    
}

#pragma mark - 我要接单保存请求

- (void)tackDataSave{
    
    
    LxDBAnyVar(_quyuArray);

    NSMutableArray * quyuArray = [NSMutableArray new];
    [_quyuArray enumerateObjectsUsingBlock:^(id selectPoi, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([selectPoi isKindOfClass:[AMapTip class]]) {
            AMapTip *obj = (AMapTip * )selectPoi;
            NSMutableDictionary * dict = [NSMutableDictionary new];
//            dict[@"city"] = [selectPoi.city stringByReplacingOccurrencesOfString:@"市" withString:@""]  ;//服务区域城市名
            dict[@"address"] = [NSString stringWithFormat:@"%@",obj.name];
            dict[@"lng"] = @(obj.location.longitude);
            dict[@"lat"] =  @(obj.location.latitude);
            [quyuArray addObject:dict];
        }else if ([selectPoi isKindOfClass:[TackModel class]]){
            TackModel *obj = (TackModel * )selectPoi;
            NSMutableDictionary * dict = [NSMutableDictionary new];
            //            dict[@"city"] = [selectPoi.city stringByReplacingOccurrencesOfString:@"市" withString:@""]  ;//服务区域城市名
            dict[@"address"] = obj.address;
            dict[@"lng"] = obj.lng;
            dict[@"lat"] = obj.lat;
            [quyuArray addObject:dict];
        }
    }];
    
    if(quyuArray.count == 0){
        [self showErrorText:@"请选择服务区域"];
        return;
    }
    
//    NSString *service_sectorStr = [LocalData getService_sector];
    
//    if(_service_sectorStr.length == 0){
//        
//        [self showErrorText:@"请选择服务领域"];
//        return;
//    }
    if(_service_stime.length == 0){
        
        [self showErrorText:@"请选择开始时间"];
        return;
    }
    if(_service_etime.length == 0){
        
        [self showErrorText:@"请选择结束时间"];
        return;
    }
    
    NSString * service_stime =[Utool timestampForDateFromString:_service_stime withFormat:@"yyyy.MM.dd HH:mm"];
    NSString * service_etime =[Utool timestampForDateFromString:_service_etime withFormat:@"yyyy.MM.dd HH:mm"];

    if([service_stime integerValue] > [service_etime integerValue]){
        [self showErrorText:@"结束时间不能早于开始时间"];
        return;
    }

    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
//    params[@"service_sector"] = service_sectorStr;
    params[@"service_stime"] =service_stime;
    params[@"service_etime"] =service_etime;
    params[@"citys"] = [quyuArray JSONString_Ext];

    
    [self showLoading];
    
    [MCNetTool postWithUrl:HttpMainTackDataSave params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self dismissLoading];
        
        
        [Utool performBlock:^{
            
            [self showSuccessText:@"需求发布成功"];

            [self.navigationController popViewControllerAnimated:YES];
            
        } afterDelay:1.0f];

        
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];


}


#pragma mark - 客户发单的必要信息
- (void)showaddbillDataJ{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    
    [MCNetTool postWithCacheUrl:HttpMainShowaddbill params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        ShowaddbillModel * showaddbillModel = [ShowaddbillModel mj_objectWithKeyValues:requestDic];
        
        _showaddbillModel = showaddbillModel;
        
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        
    }];
    
    
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _quyuArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SettingCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text =_titles[indexPath.section];
    
    if ([self.spaceTimeModel yw_notNull]){
        if (indexPath.section == 0){
            if (self.quyuArray.count > indexPath.row){
                TackModel *tackModel = self.quyuArray[indexPath.row];
                cell.detailTextLabel.text = tackModel.address;
            }
        }else if (indexPath.section == 1){
            cell.detailTextLabel.text = self.service_stime;
        }else{
            cell.detailTextLabel.text = self.service_etime;
        }
    }
    
//    if (indexPath.section == 3) {
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
//        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
//     }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return  44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(indexPath.section == 0){
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        // 选择服务区域
        ChooseMapViewController * vc = [[ChooseMapViewController alloc]initWithNibName:@"ChooseMapViewController" bundle:nil];
        vc.chooseSeviceAreaBlock =^(AMapTip * selectPoi){
             LxDBAnyVar(selectPoi.name);
             cell.detailTextLabel.text = selectPoi.name;
             [_quyuArray replaceObjectAtIndex:indexPath.row withObject:selectPoi];
         };
         [self.navigationController pushViewController:vc animated:YES];
        
    }
    /*
    if(indexPath.section == 1){
        // 选择服务领域
        ChooseSeviceDomainViewController * vc = [[ChooseSeviceDomainViewController alloc]initWithNibName:@"ChooseSeviceDomainViewController" bundle:nil];
        vc.domains = _showaddbillModel.service_sector;
        vc.allowsMultipleSelection = YES;
        vc.selectedContactIds = [self contactIdsForContacts:_selectedDomainsIds];

        vc.domainsChooseSeviceDomainViewBlock = ^(NSArray * somains){
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            LxDBAnyVar(somains);
            _selectedDomainsIds =somains;

            NSMutableArray * titles = [NSMutableArray new];
            NSMutableArray * ids = [NSMutableArray new];

            [somains enumerateObjectsUsingBlock:^( Service_Sector12 *  user , NSUInteger idx, BOOL * _Nonnull stop) {
                 [titles addObject:user.gc_name];
                [ids addObject:user.gc_id];

            }];
            NSString * titleStr = [titles string];
             cell.detailTextLabel.text = titleStr;
            
            _service_sectorStr = [ids string];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    */
    if(indexPath.section == 1){
        STPickerDate *pickerDate = [[STPickerDate alloc]initWithRow:5];
        pickerDate.pickerDate3Block = ^(NSInteger year,NSInteger month,NSInteger day,NSString * time){
            
            _service_stime = time;
            
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = time;//[Utool comment_timeStamp2TimeFormatter:time];// [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",year,month,day,hour,minute];
            
        };
        [pickerDate show];
    }
    
    if(indexPath.section == 2){
        
        STPickerDate *pickerDate = [[STPickerDate alloc]initWithRow:5];
        pickerDate.pickerDate3Block = ^(NSInteger year,NSInteger month,NSInteger day,NSString * time){
        
            _service_etime =  time;
            
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = time;//[Utool comment_timeStamp2TimeFormatter:time];// [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",year,month,day,hour,minute];
        };
        [pickerDate show];
    }
    
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






- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section ==0){
        _sectionFooterView = [ReceivingOrderEditSectionView receivingOrderEditSectionView];
        [_sectionFooterView.addBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {

             NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_quyuArray.count inSection:0];
            [indexPaths addObject: indexPath];
            [_quyuArray addObject:@"   "];
            //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            
            if (_quyuArray.count == 3) {
                _sectionFooterView.addBtn.enabled = NO;;
                _sectionFooterView.descLab.hidden = YES;
             }
        }];
         return _sectionFooterView;
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



#pragma mark - tableView删除section或者row
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
         if (_quyuArray.count < 2) {
            return UITableViewCellEditingStyleNone;
         }
         return UITableViewCellEditingStyleDelete;
     }
    return UITableViewCellEditingStyleNone;
}
/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
         if (editingStyle == UITableViewCellEditingStyleDelete){
            [_quyuArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];//移除tableView中的
            if (_quyuArray.count < 3) {
                 _sectionFooterView.addBtn.enabled = YES;;
                 _sectionFooterView.descLab.hidden = NO;
             }
        }
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
