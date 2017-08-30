//
//  FilterView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/1.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "FilterView.h"
#import "FilterViewRangeCell.h"
#import "FilterViewCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "STPickerDate.h"
#import "ShopListModel.h"
#import "NSDate+Utils.h"
#import "ShopFilterViewCell.h"

#define offset [UIScreen mainScreen].bounds.size.width/3*2

@interface FilterView()<UITableViewDataSource, UITableViewDelegate, FilterViewCellDelegate,ShopFilterViewCellDelegate>
{
//    AXPriceRangeCell *priceRangeCell;
}


@property (weak, nonatomic) IBOutlet UIView *contentView;


/** 展示tableView */
@property (strong, nonatomic) TPKeyboardAvoidingTableView *tableV;
/** 选项标题数组 */
@property (strong, nonatomic) NSMutableArray *headerTitArr;
/** 选项数据数组 */
@property (strong, nonatomic) NSMutableArray *dataArr;
/** 是否选中状态字典 */
@property (strong, nonatomic) NSMutableDictionary *selectedDict;

//选中的地址
@property (nonatomic, strong) NSMutableArray *selectedArea;


@property (nonatomic, strong) NSArray *areaList;

@end


@implementation FilterView

- (NSMutableArray *)selectedArea{
    if(!_selectedArea){
        _selectedArea = [NSMutableArray array];
    }
    return _selectedArea;
}

- (FilterView *)filterView{
    FilterView *item = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] lastObject];
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        self   =  [self filterView];
        _bgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
         self.frame = frame;
        
        UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViewAction:)];
        [_bgView addGestureRecognizer:tap];
        
  
        [self aaaaa];
        
    }
    return self;
}

- (void)aaaaa{
    _selectedDict = [NSMutableDictionary new];
    self.dataArr= [NSMutableArray new];
    self.headerTitArr = [NSMutableArray arrayWithObjects:@"预约"
                         ,@"自定义日期"
                         ,@"服务金额"
                         ,@"自定义价格"
                         ,@"服务区域"
                         ,nil];
    
    NSArray * yuyueArray = @[@"全部",@"7天以内",@"15天以内",@"15天以上"];
    NSArray * yuyueArray1=@[];
    NSArray * priceArray = @[@"全部",@"4000",@"2000-5000",@"5000以上"];
    NSArray * priceArray1 = @[];
    [self.dataArr addObject:yuyueArray];
    [self.dataArr addObject:yuyueArray1];
    [self.dataArr addObject:priceArray];
    [self.dataArr addObject:priceArray1];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    self.areaList = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    
     [self.tableV reloadData];


}




#pragma mark - 重置
- (IBAction)resetBtnAction:(id)sender {
    [self.selectedDict removeAllObjects];
    [self.selectedArea removeAllObjects];
    for (int i = 0; i < self.headerTitArr.count; i++) {
        NSMutableArray *selectedArr = [NSMutableArray array];
        for (int i = 0; i < self.dataArr.count; i++) {
            [selectedArr addObject:@"NO"];
        }
        if (i == 4){
            [self.selectedDict setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%d", i]];
        }else{
            [self.selectedDict setObject:selectedArr forKey:[NSString stringWithFormat:@"%d", i]];
        }
        
    }
    [self.tableV reloadData];

}

#pragma mark - 确认按钮
- (IBAction)trueBtnAction:(id)sender {
    
    if (_filterViewBlock) {
        _filterViewBlock(self.selectedDict);
    }
    
     if (_delegate && [_delegate respondsToSelector:@selector(pickerViewControllerdismis:)]) {
        [self.delegate pickerViewControllerdismis:self.selectedDict];
     }
    
    
}

/** 字典转json字符串 */
- (NSString*)dictionaryToJson:(id)data
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


#pragma mark -

#pragma mark - AF_BrandCellDelegate
/** 取得选中选项的值，改变选项状态，刷新列表 */
- (void)selectedValueChangeBlock:(NSInteger)section key:(NSInteger)index value:(NSString *)value{
    
    
     [self.selectedDict setObject:[NSString stringWithFormat:@"%@",@(index)] forKey:[NSString stringWithFormat:@"%@",@(section)]];
    
}
#pragma mark -

#pragma mark - tableView UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headerTitArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FilterViewCell *cell = [[FilterViewCell alloc]init];
        NSArray * array =_dataArr[indexPath.section];
        cell.attributeArr =array;
        return cell.height;
    }else  if (indexPath.section == 1) {
        return 44;

    }else if (indexPath.section == 2) {
        FilterViewCell *cell = [[FilterViewCell alloc]init];
        NSArray * array =_dataArr[indexPath.section];
        cell.attributeArr =array;
        return cell.height;

    }else  if (indexPath.section == 3) {
        return 44;
    }else if (indexPath.section == 4) {
        ShopFilterViewCell *cell = [[ShopFilterViewCell alloc]init];
        cell.attributeArr2 = self.areaList;
        return cell.height;
    }
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, offset, 40)];
    UILabel *titLab = [[UILabel alloc]init];
    titLab.text = _headerTitArr[section];
    titLab.font = [UIFont systemFontOfSize:13.0];
    CGSize titSize = [titLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
    titLab.textColor = [UIColor grayColor];
    titLab.frame = CGRectMake(5, 0, titSize.width, 40);
    [myView addSubview:titLab];
    return myView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        // 预约
        NSArray * dataArray = self.dataArr[indexPath.section];
        
        FilterViewCell *cell = [FilterViewCell cellWithTableView:tableView dataArr:dataArray indexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        NSString *sectionStr = [NSString stringWithFormat:@"%ld", indexPath.section];
        cell.selectedArr = self.selectedDict[sectionStr];
         cell.attributeArr = dataArray;
        return cell;

    }
    else if (indexPath.section == 1) {
        
        // 自定义日期
        FilterViewRangeCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FilterViewRangeCell"];
        cell.btn1.hidden = NO;
        cell.btn2.hidden = NO;
        cell.priceText1.placeholder= @"开始时间";
        cell.priceText2.placeholder= @"结束时间";
        [cell.btn1 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            
            STPickerDate *pickerDate = [[STPickerDate alloc]initWithRow:3];
            pickerDate.pickerDate3Block = ^(NSInteger year,NSInteger month,NSInteger day,NSString * time){
                NSString * selectTime =[NSString stringWithFormat:@"%ld:%.2ld:%.2ld",year,month,day];
                cell.priceText1.text = selectTime;
                [self.selectedDict setObject:time forKey:@"111"];
            };
            [pickerDate show];

        }];
        [cell.btn2 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            
            STPickerDate *pickerDate = [[STPickerDate alloc]initWithRow:3];
            pickerDate.pickerDate3EndBlock = ^(NSInteger year,NSInteger month,NSInteger day,NSString * time){
                NSString * selectTime =[NSString stringWithFormat:@"%ld:%.2ld:%.2ld",year,month,day];
                cell.priceText2.text = selectTime;
                [self.selectedDict setObject:time forKey:@"112"];
            };
            [pickerDate show];
        }];
        
        return cell;
        
    }
    else if (indexPath.section == 2) {
        
        // 服务金额
        NSArray * dataArray = self.dataArr[indexPath.section];
        FilterViewCell *cell = [FilterViewCell cellWithTableView:tableView dataArr:dataArray indexPath:indexPath];
         cell.indexPath = indexPath;
        cell.delegate = self;
        NSString *sectionStr = [NSString stringWithFormat:@"%ld", indexPath.section];
        cell.selectedArr = self.selectedDict[sectionStr];
        cell.attributeArr = dataArray;
        return cell;
    }
    else if (indexPath.section == 3) {
        
        // 自定义价格
        
        FilterViewRangeCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FilterViewRangeCell"];
        cell.btn1.hidden = YES;
        cell.btn2.hidden = YES;
 

        cell.aXPriceRange1CellBlock =^(NSString *price){
        
            [self.selectedDict setObject:price forKey:@"211"];

        };
        cell.aXPriceRange2CellBlock =^(NSString *price){
            
            [self.selectedDict setObject:price forKey:@"212"];

        };
        
        return cell;
    }
    else if (indexPath.section == 4) {
        
        // 服务区域
        ShopFilterViewCell *cell = [ShopFilterViewCell cellWithTableView:tableView dataArray:[NSMutableArray arrayWithArray:self.areaList] indexPath:indexPath];
        cell.tag = indexPath.section;
        cell.delegate = self;
        cell.attributeArr2 = self.areaList;
        cell.selectedArr2 = self.selectedArea;
        return cell;
    }
    return nil;
}

#pragma mark -

#pragma mark - 懒加载
-(UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0,offset, kScreenHeight-64 - 50) style:UITableViewStyleGrouped];
        _tableV.backgroundColor = [UIColor whiteColor];
        /** 隐藏cell分割线 */
        [_tableV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        
        [_tableV registerNib:[UINib nibWithNibName:@"FilterViewRangeCell" bundle:nil] forCellReuseIdentifier:@"FilterViewRangeCell"];
 [_tableV registerNib:[UINib nibWithNibName:@"AXPriceRangeCell" bundle:nil] forCellReuseIdentifier:@"priceRangeCell"];
        
        [_contentView addSubview:_tableV];
    }
    return _tableV;
}

- (void)layoutSubviews{
     [super layoutSubviews];

}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
// 点击背景隐藏此视图
- (void)dismissViewAction:(UITapGestureRecognizer *)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(contactsPickerViewControllerdismis:)]) {
        [_delegate contactsPickerViewControllerdismis:self];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    if (_filterViewScrollBlock) {
        _filterViewScrollBlock();
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - AF_BrandCellDelegate
/** 取得选中选项的值，改变选项状态，刷新列表 */
- (void)shopFilterSelectedValueChangeBlock:(NSInteger)section key:(NSInteger)index value:(NSString *)value{
    
    if ([value isEqualToString:@"YES"]){
        [self.selectedArea addObject:[self.areaList[index] objectForKey:@"areaName"]];
    }else{
        if ([self.selectedArea containsObject:[self.areaList[index] objectForKey:@"areaName"]]){
            [self.selectedArea removeObject:[self.areaList[index] objectForKey:@"areaName"]];
        }
    }
    
    [self.selectedDict setObject:self.selectedArea forKey:[NSString stringWithFormat:@"%@",@(section)]];
}

@end
