//
//  ShopFilterView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopFilterView.h"
#import "ShopFilterViewCell.h"
#import "STPickerDate.h"
#import "ShopListModel.h"

#define offset [UIScreen mainScreen].bounds.size.width/3*2


@interface ShopFilterView()<UITableViewDataSource, UITableViewDelegate, ShopFilterViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

/** 展示tableView */
@property (strong, nonatomic) UITableView *tabelView;
/** 选项数据数组 */
@property (strong, nonatomic) NSMutableArray *dataArr;
/** 是否选中状态字典 */
@property (strong, nonatomic) NSMutableDictionary *selectedDict;

@end
@implementation ShopFilterView

- (ShopFilterView *)shopFilterView{
    ShopFilterView *item = [[[NSBundle mainBundle] loadNibNamed:@"ShopFilterView" owner:self options:nil] lastObject];
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self   =  [self shopFilterView];
        _bgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        self.frame = frame;
        
        UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViewAction:)];
        [_bgView addGestureRecognizer:tap];
        
        [self setDataArray:nil];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    
    _dataArr = [NSMutableArray arrayWithArray:dataArray];
     _selectedDict = [NSMutableDictionary dictionary];
          NSMutableArray *selectedArr = [NSMutableArray array];
        for (int i = 0; i < self.dataArr.count; i++) {
            [selectedArr addObject:@"NO"];
           [self.selectedDict setObject:selectedArr forKey:@"0"];
        }
    
    [self.tabelView reloadData];
    
}



#pragma mark - 重置
- (IBAction)resetBtnAction:(id)sender {
    
     [self.selectedDict removeAllObjects];
      NSMutableArray *selectedArr = [NSMutableArray array];
    for (int i = 0; i < _dataArr.count; i++) {
        [selectedArr addObject:@"NO"];
    }
    [_selectedDict setObject:selectedArr forKey:@"0"];
     [self.tabelView reloadData];
    
}

#pragma mark - 确认按钮
- (IBAction)trueBtnAction:(id)sender {
    
    NSMutableArray *strArr = [NSMutableArray array];//
    NSString *sectionStr = @"0";
    NSMutableArray *sectionArr = self.selectedDict[sectionStr];
    
     for (int i = 0; i < sectionArr.count; i++) {
        if ([sectionArr[i] isEqualToString:@"YES"]) {
             [strArr addObject:self.dataArr[i]];
        }
    }
    if (_shopFilterViewBlock) {
        _shopFilterViewBlock(strArr);
    }
     DeLog(@"筛选条件 : \n%@", strArr);
    
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

    NSString *sectionStr = [NSString stringWithFormat:@"%ld", (long)section];
    NSMutableArray *arr = self.selectedDict[sectionStr];
    [arr replaceObjectAtIndex:index withObject:value];
    [self.selectedDict setObject:arr forKey:sectionStr];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [self.tabelView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    LxDBAnyVar(_selectedDict);
}
#pragma mark -

#pragma mark - tableView UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    ShopFilterViewCell *cell = [[ShopFilterViewCell alloc]init];
     cell.attributeArr =_dataArr;
    return cell.height;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, offset, 40)];
    UILabel *titLab = [[UILabel alloc]init];
    titLab.text = @"商品位置";
    titLab.font = [UIFont systemFontOfSize:13.0];
    CGSize titSize = [titLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
    titLab.textColor = [UIColor grayColor];
    titLab.frame = CGRectMake(5, 0, titSize.width, 40);
    [myView addSubview:titLab];
    return myView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopFilterViewCell *cell = [ShopFilterViewCell cellWithTableView:tableView dataArray:_dataArr indexPath:indexPath];
    cell.tag = indexPath.section;
    cell.delegate = self;
    NSString *sectionStr = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    cell.selectedArr = _selectedDict[sectionStr];
    cell.attributeArr = _dataArr;
    return cell;
   
}

#pragma mark -

#pragma mark - 懒加载
-(UITableView *)tabelView{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,offset, kScreenHeight-64 - 50) style:UITableViewStyleGrouped];
        _tabelView.backgroundColor = [UIColor whiteColor];
        /** 隐藏cell分割线 */
        [_tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        
        [_tabelView registerNib:[UINib nibWithNibName:@"AXPriceRangeCell" bundle:nil] forCellReuseIdentifier:@"priceRangeCell"];
        
        [_contentView addSubview:_tabelView];
    }
    return _tabelView;
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


@end
