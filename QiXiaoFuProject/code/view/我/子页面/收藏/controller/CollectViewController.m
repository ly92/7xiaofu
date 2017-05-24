
//
//  CollectViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CollectViewController.h"
#import "PDCollectionViewFlowLayout.h"
#import "CollectCell.h"
#import "CollectGoodModel.h"
#import "ShopDetaileViewController.h"

@interface CollectViewController ()<PDCollectionViewFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic)  NSInteger page;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收藏";
    
    _dataArray = [NSMutableArray new];
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
    

    
    [_collectionView headerAddMJRefresh:^{
        
        [self loadShopListWithPage:1];
        
    }];
    [_collectionView footerAddMJRefresh:^{
        
        [self loadShopListWithPage:_page];
    }];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self loadShopListWithPage:1];

}





- (void)loadShopListWithPage:(NSInteger )page{
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"store_id"] = @"1";
    params[@"userid"] = kUserId;
    params[@"curpage"] = @(page);
    
    [MCNetTool postWithCachePageUrl:HttpShopCollectList params:params success:^(NSDictionary *requestDic, NSString *msg, BOOL hasmore, NSInteger page_total) {
        
        _page ++;
        
        NSArray *   array = [CollectGoodModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        [_collectionView reloadData];
        if (array.count < 20) {
            [_collectionView hidenFooter];
        }
        page==1?[_collectionView headerEndRefresh]:[_collectionView footerEndRefresh];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_collectionView];

    } fail:^(NSString *error) {
        page==1?[_collectionView headerEndRefresh]:[_collectionView footerEndRefresh];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_collectionView];
    }];
    

}


#pragma mark - MUCollectionViewFlowLayoutDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
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
    
    CollectGoodModel * collectGoodModel = _dataArray[indexPath.row];
    cell.collectGoodModel = collectGoodModel;
    cell.backgroundColor =[UIColor clearColor];
     return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DeLog(@"indexPath section: %ld  row:%ld", (long)indexPath.section, (long)indexPath.row);
    
 
    CollectGoodModel * collectGoodModel = _dataArray[indexPath.row];
    ShopDetaileViewController * vc = [[ShopDetaileViewController alloc]initWithNibName:@"ShopDetaileViewController" bundle:nil];
    vc.goods_id =collectGoodModel.goods_id;
    vc.goods_image = collectGoodModel.goods_image;
    [self.navigationController pushViewController:vc animated:YES];

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
