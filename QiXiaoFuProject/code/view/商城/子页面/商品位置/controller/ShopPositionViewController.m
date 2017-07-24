//
//  ShopPositionViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/3.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopPositionViewController.h"
#import "EngineerDistributedViewController.h"
#import "ShopPositionModel.h"
#import "EngineerDistributedMapViewController.h"


@interface ShopPositionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *shopArray;

@property (nonatomic, strong) ShopPositionModel * shopPositionModel;

@end

@implementation ShopPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品位置";
    
    _titles = @[@"商品库存",@"工程师库存"];
    _contentArray = [NSMutableArray new];
    _shopArray = [NSMutableArray new];
    
    [_tableView setSeparatorColor:kHexColor(E0E0E0)];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SettingCell"];
    _tableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"goods_id"] = _goods_id;
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    
    [MCNetTool postWithCacheUrl:HttpShopStorageDetail params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _shopPositionModel = [ShopPositionModel mj_objectWithKeyValues:requestDic];
        [_contentArray setArray:_shopPositionModel.eng_list];
        [_shopArray setArray:_shopPositionModel.shop_list];
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemCancleWithTitle:@"地图" target:self action:@selector(mapItemAction:)];

    
}

- (void)mapItemAction:(UIBarButtonItem *)item{
    
    EngineerDistributedMapViewController * vc= [[EngineerDistributedMapViewController alloc] initWithNibName:@"EngineerDistributedMapViewController" bundle:nil];
    vc.goods_id = _goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}






#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_shopArray count];
    }
     return [_contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SettingCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];

    if (indexPath.section == 0) {
//        cell.textLabel.text =_shopPositionModel.shop_list.name;
        Shop_List * shop_List = _shopArray[indexPath.row];
        cell.textLabel.text =shop_List.name;
        cell.detailTextLabel.text = shop_List.count;
        
     }else{
        Eng_List * eng_List = _contentArray[indexPath.row];
        cell.textLabel.text =eng_List.name;
        cell.detailTextLabel.text = eng_List.count;
    }
    
    if (indexPath.section == 0) {
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage new]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.detailTextLabel.textColor = kThemeColor;
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1){
        Eng_List * eng_List = _contentArray[indexPath.row];
         EngineerDistributedViewController * vc= [[EngineerDistributedViewController alloc]initWithNibName:@"EngineerDistributedViewController" bundle:nil];
        vc.navigationItem.title = eng_List.name;
        vc.area_id =eng_List.area_id;
        vc.goods_id =_goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    if (section==1 && (_contentArray.count!=0)) {
        titleLab.text = [NSString stringWithFormat:@"  %@",_titles[section]];
    }else if(section==0){
        titleLab.text = [NSString stringWithFormat:@"  %@",_titles[section]];
    }
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = kHexColor(505050);
    return titleLab;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
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
