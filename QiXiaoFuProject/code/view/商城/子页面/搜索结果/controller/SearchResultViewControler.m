//
//  SearchResultViewControler.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SearchResultViewControler.h"
#import "PDCollectionViewFlowLayout.h"
#import "CollectCell.h"
#import "ShopListModel.h"
#import "ShopDetaileViewController.h"
#import "NSArray+Utils.h"
#import "ShopFilterView.h"


@interface SearchResultViewControler ()<PDCollectionViewFlowLayoutDelegate,ShopFilterViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray * shopListArray;// 商品列表
@property (nonatomic ,strong) NSArray * area_list;// 地区列表
@property (nonatomic ,strong) NSArray * searching_type;// 筛选条件

@property (nonatomic ,assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray * area_ListArray;

@property (strong, nonatomic) ShopFilterView * filterView;

@property (strong, nonatomic) UIButton * filtButton;
@end

@implementation SearchResultViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _filtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _filtButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_filtButton setTitle:@"筛选" forState:UIControlStateNormal];
    [_filtButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_filtButton setTitleColor:RGB(248, 182, 182) forState:UIControlStateHighlighted];
    [_filtButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_filtButton sizeToFit];
    [_filtButton addTarget:self action:@selector(filterItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_filtButton];
    
    
    _shopListArray = [NSMutableArray new];
    _area_ListArray = [NSMutableArray new];
    _page = 1;
    
    
    PDCollectionViewFlowLayout * layout = [[PDCollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    layout.columnCount = 1;
    
    _collectionView.collectionViewLayout= layout;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellWithReuseIdentifier:@"CollectCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:CZCollectionElementKindSectionHeader withReuseIdentifier:@"CustomersHeaderReusableView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:CZCollectionElementKindSectionFooter withReuseIdentifier:@"CustomersFooterReusableView"];
    
    
    [self loadShopListWithGc_id:_gc_id page:1];
    
    [_collectionView headerAddMJRefresh:^{
        
        [_area_ListArray removeAllObjects];
        [self loadShopListWithGc_id:_gc_id page:1];
        
    }];
    
    
    [_collectionView footerAddMJRefresh:^{
        
        [self loadShopListWithGc_id:_gc_id page:_page];
        
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadShopListWithGc_id:(NSString *)gc_id page:(NSInteger )page{
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"store_id"] = @"1";//店铺ID
    params[@"gc_id"] = gc_id;//商品分类ID
    params[@"key"] = @"4";// 排序类型【1:销量】【2:人气（访问量）】【3:价格】【4:新品】
    params[@"order"] = @"2";//排序方式【1:升序】【2:降序】
    params[@"curpage"] = @(page);//页数
    if (_keyword) {
        params[@"keyword"] = _keyword;//搜索商品名称
    }

    if (_area_ListArray.count != 0) {
        NSString *area_id = [_area_ListArray componentsJoinedByString:@","];
        params[@"area_id"] = area_id;
//        params[@"area_id"] = [_area_ListArray JSONString_Ext];//筛选条件子ID数组
    }
    
    
    [MCNetTool postWithCachePageUrl:HttpShopList params:params success:^(NSDictionary *requestDic, NSString *msg, BOOL hasmore, NSInteger page_total) {
        
        _page = page;
        _page ++;
        
        ShopListModel * shopListModel = [ShopListModel mj_objectWithKeyValues:requestDic];
        
        _area_list =shopListModel.area_list;
        
        page_total==1?[_shopListArray setArray:shopListModel.goods_list]:[_shopListArray addObjectsFromArray:shopListModel.goods_list];
        [_collectionView reloadData];
        
        if (shopListModel.goods_list.count < 20) {
            [_collectionView hidenFooter];
        }
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_shopListArray empty:EmptyDataTableViewDefault withScrollView:_collectionView];
        
        page_total==1?[_collectionView headerEndRefresh]:[_collectionView footerEndRefresh];
        
        
    } fail:^(NSString *error) {
        page==1?[_collectionView headerEndRefresh]:[_collectionView footerEndRefresh];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_shopListArray empty:EmptyDataTableViewDefault withScrollView:_collectionView];
        
    }];
    
    
    
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}




#pragma mark - MUCollectionViewFlowLayoutDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _shopListArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    return (kScreenWidth - 5)/2/183*253;
    
    return 120;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth,0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CZCollectionElementKindSectionHeader])
    {
        UICollectionReusableView * customersFooterReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CustomersHeaderReusableView" forIndexPath:indexPath];
        customersFooterReusableView.backgroundColor = [UIColor whiteColor];
        
        return customersFooterReusableView;
    }
    else if ([kind isEqualToString:CZCollectionElementKindSectionFooter])
    {
        UICollectionReusableView * customersFooterReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CustomersFooterReusableView" forIndexPath:indexPath];
        customersFooterReusableView.backgroundColor = [UIColor whiteColor];
        return customersFooterReusableView;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectCell" forIndexPath:indexPath];
    Goods_List * goodlist = _shopListArray[indexPath.item];
    cell.good_list = goodlist;
    cell.backgroundColor =[UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DeLog(@"indexPath section: %ld  row:%ld", (long)indexPath.section, (long)indexPath.row);
    
    Goods_List * goodlist = _shopListArray[indexPath.item];
    
    ShopDetaileViewController * vc = [[ShopDetaileViewController alloc]initWithNibName:@"ShopDetaileViewController" bundle:nil];
    vc.goods_id =goodlist.goods_id;
    vc.goods_image = goodlist.goods_image_url;

    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 筛选
// 筛选
- (void)filterItemAction:(UIButton *)item{
    WEAKSELF
    item.selected =!item.selected;
    if (!_filterView) {
        
        _filterView = [[ShopFilterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height)];
        _filterView.dataArray = _area_list;
        _filterView.delegate = self;
        [self.view addSubview:_filterView];
        _filterView.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            //            _filterView.frame = CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height);
            _filterView.alpha = 1;
            
        } completion:^(BOOL finished) {
        }];
        
        
        _filterView.shopFilterViewBlock =^(NSArray * idArray){
            
            LxDBAnyVar(idArray);
            [weakSelf.area_ListArray removeAllObjects];
            [idArray enumerateObjectsUsingBlock:^(Area_List * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.area_ListArray addObject:obj.area_id];
            }];
            
            [weakSelf loadShopListWithGc_id:weakSelf.gc_id page:1];
            
            [weakSelf dismisFilterView];
        };
        
        
    }else{
        [self dismisFilterView];
        
    }
}


#pragma mark - FilterViewDelegate

- (void)contactsPickerViewControllerdismis:(ShopFilterView *)controller{
    [self dismisFilterView];
}

- (void)pickerViewControllerdismis:(NSDictionary *)dict{
    
    LxDBAnyVar(dict);
    
}


- (void)dismisFilterView{
    
    [UIView animateWithDuration:0.25 animations:^{
        //        _filterView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.view.frame.size.height);
        _filterView.alpha =0;
    } completion:^(BOOL finished) {
        [_filterView removeFromSuperview];
        _filterView = nil;
        _filtButton.selected = NO;
    }];
    
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
