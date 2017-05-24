//
//  ChooseAreViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChooseAreViewController.h"
@class AdressModel;
@interface ChooseAreViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSIndexPath *indexPath;//用来记录tableviewcell选中位置
@property (nonatomic, strong)NSArray *adressList;//地区列表
@end

@implementation ChooseAreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"选择新地区";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"保存" target:self action:@selector(saveAreItemAction:)];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"area_id"] = @(0);
    params[@"store_id"] = @"1";
    [MCNetTool postWithCacheUrl:HttpAdressAreaList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        _adressList = [AreaModel mj_objectArrayWithKeyValuesArray:requestDic];
        [_tableView reloadData];
    } fail:^(NSString *error) {
    }];

}

- (void)saveAreItemAction:(UIBarButtonItem *)item{

    if (_chooseAreBlock) {
        AreaModel * adressModel = _adressList[_indexPath.row];
        _chooseAreBlock(adressModel.area_name,adressModel.area_id);
    }
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _adressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    AreaModel * adressModel = _adressList[indexPath.row];
    cell.textLabel.text =adressModel.area_name;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    newCell.tintColor = kThemeColor;
    if (self.indexPath && self.indexPath != indexPath) {
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.indexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.indexPath = indexPath;
    
    
    
    
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





@implementation AreaModel



@end



