//
//  ChooseArea3ViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChooseArea3ViewController.h"


#define windowContentWidth  ([[UIScreen mainScreen] bounds].size.width)

//当前tableview所处的状态
NS_ENUM(NSInteger,PickState) {
    ProvinceState,//选择省份状态
    CityState,//选择城市状态
    DistrictState//选择区、县状态
};



@interface ChooseArea3ViewController ()
{
    AreasModel *areasModel1;
    AreasModel *areasModel2;
    AreasModel *areasModel3;
}


//省份选择Button
@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
//城市选择Button
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
//区、县选择Button
@property (weak, nonatomic) IBOutlet UIButton *districtBtn;
//滑动线条
@property (nonatomic, strong)UIView *selectLine;



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;

//省级数组
@property (nonatomic, strong)NSArray *provinceArr;
//城市数组
@property (nonatomic, strong)NSArray *cityArr;
//区、县数组
@property (nonatomic, strong)NSArray *districtArr;
@end

@implementation ChooseArea3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择地区";
    
    _selectLine = [[UIView alloc]initWithFrame:CGRectMake(10, 49, 1, 1)];
    _selectLine.backgroundColor = kThemeColor;
    [_topView addSubview:_selectLine];
    _selectLine.hidden = NO;
    
    [self provinceBtnAction:nil];
    
    _tableView.tableFooterView = [UIView new];
    
    [self oneData];
    
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)provinceBtnAction:(id)sender {
    
    _selectLine.hidden = NO;
    PickState = ProvinceState;
    [_tableView reloadData];
    
    CGFloat width = [self getBtnWidth:_provinceBtn];
    
    [UIView animateWithDuration:0.4 animations:^{
        _selectLine.frame = CGRectMake((windowContentWidth/3-width)/2 , 41, width, 1);
    }];

    
}

- (IBAction)cityBtnAction:(id)sender {
    _selectLine.hidden = NO;
    PickState = CityState;
    [_tableView reloadData];
    CGFloat width = [self getBtnWidth:_cityBtn];
    
    [UIView animateWithDuration:0.4 animations:^{
        _selectLine.frame = CGRectMake((windowContentWidth/3-width)/2 + windowContentWidth/3, 41, width, 1);
        
    }];

    
}

- (IBAction)districBtnAction:(id)sender {
    
    _selectLine.hidden = NO;
    PickState = DistrictState;
    [_tableView reloadData];
    CGFloat width = [self getBtnWidth:_districtBtn];
    
    [UIView animateWithDuration:0.4 animations:^{
        _selectLine.frame = CGRectMake((windowContentWidth/3-width)/2  + windowContentWidth * 2/3, 41, width, 1);
        
    }];
    
}


- (void)oneData{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"area_id"] = @(0);
    params[@"store_id"] = @"1";
    [MCNetTool postWithCacheUrl:HttpAdressAreaList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        _provinceArr = [AreasModel mj_objectArrayWithKeyValuesArray:requestDic];
        [_tableView reloadData];
    } fail:^(NSString *error) {
    }];
}

- (void)twoDataProvinceId:(NSString *)province_id{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"area_id"] = province_id;
    params[@"store_id"] = @"1";
    [MCNetTool postWithCacheUrl:HttpAdressAreaList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        _cityArr = [AreasModel mj_objectArrayWithKeyValuesArray:requestDic];
        [_tableView reloadData];
    } fail:^(NSString *error) {
    }];
}


- (void)threeDataCityId:(NSString *)city_id{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"area_id"] = city_id;
    params[@"store_id"] = @"1";
    [MCNetTool postWithCacheUrl:HttpAdressAreaList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        _districtArr = [AreasModel mj_objectArrayWithKeyValuesArray:requestDic];
        [_tableView reloadData];
    } fail:^(NSString *error) {
    }];
}

-(CGFloat)getBtnWidth:(UIButton *)btn {
    CGRect tmpRect = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil];
    CGFloat width = tmpRect.size.width;
    return width;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(PickState == ProvinceState) {
        
        return _provinceArr.count;
        
    }else if (PickState == CityState) {
        
        return _cityArr.count;
        
    }else {
        
        return _districtArr.count;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if(PickState == ProvinceState) {
        
        AreasModel * areaModel =_provinceArr[indexPath.row];
        cell.textLabel.text = areaModel.area_name;
        
    }else if(PickState == CityState) {
        
        AreasModel * areaModel =_cityArr[indexPath.row];
        cell.textLabel.text = areaModel.area_name;
        
    }else {
        
        AreasModel * areaModel =_districtArr[indexPath.row];
        cell.textLabel.text = areaModel.area_name;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectLine.hidden = NO;
    if(PickState == ProvinceState) {
        //当tableview所处为省份选择状态时，点击cell 进入城市选择状态
        PickState = CityState;
        
        AreasModel * areaModel  = [_provinceArr objectAtIndex: indexPath.row];
        areasModel1 = areaModel;
        
        
        [_provinceBtn setTitle:areaModel.area_name forState:UIControlStateNormal];
        [_cityBtn setTitle:@"" forState:UIControlStateNormal];
        [_districtBtn setTitle:@"" forState:UIControlStateNormal];
        
        
        CGFloat width = [self getBtnWidth:_provinceBtn];
        [UIView animateWithDuration:0.4 animations:^{
            _selectLine.frame = CGRectMake((windowContentWidth/3-width)/2, 41, width, 1);
        }];
        
        
        
        [self twoDataProvinceId:areaModel.area_id];
        
        
    }else if (PickState == CityState) {
        PickState = DistrictState;
        
        
        AreasModel * areaModel  = [_cityArr objectAtIndex: indexPath.row];
        
        areasModel2 = areaModel;

        
        [_cityBtn setTitle:areaModel.area_name forState:UIControlStateNormal];
        [_districtBtn setTitle:@"" forState:UIControlStateNormal];
        
        CGFloat width = [self getBtnWidth:_cityBtn];
        
        [UIView animateWithDuration:0.4 animations:^{
            _selectLine.frame = CGRectMake((windowContentWidth/3-width)/2 + windowContentWidth/3, 41, width, 1);
            
        }];
        [self threeDataCityId:areaModel.area_id];
        
    }else {
        
        
        AreasModel * areaModel  = [_districtArr objectAtIndex: indexPath.row];
        areasModel3 = areaModel;
        
        [_districtBtn setTitle:areaModel.area_name forState:UIControlStateNormal];
        CGFloat width = [self getBtnWidth:_districtBtn];
        [UIView animateWithDuration:0.4 animations:^{
            _selectLine.frame = CGRectMake((windowContentWidth/3-width)/2 + windowContentWidth * 2/3, 41, width, 1);
        }];
        if (_chooseArea3ViewBlock) {
            _chooseArea3ViewBlock(areasModel1,areasModel2,areasModel3);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
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



@implementation AreasModel

@end


