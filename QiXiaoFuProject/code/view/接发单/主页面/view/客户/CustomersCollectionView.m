//
//  CustomersCollectionView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CustomersCollectionView.h"
#import "PDCollectionViewFlowLayout.h"
#import "CustomersHeaderReusableView.h"
#import "EngineerCell.h"
#import "OrderMainModel.h"


static NSString *identifier = @"EngineerCell";


@interface CustomersCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate,PDCollectionViewFlowLayoutDelegate>{
    
    
    
}

@end


@implementation CustomersCollectionView

+ (CustomersCollectionView *)customersCollectionView{
    
    PDCollectionViewFlowLayout * layout = [[PDCollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    //    layout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.columnCount = 3;
    
    
    CustomersCollectionView * collectionView = [[CustomersCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
//    collectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    collectionView.backgroundColor = RGB(247, 247, 247);
    
    //    UIEdgeInsets insets = {top, left, bottom, right};
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"EngineerCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    [collectionView registerNib:[UINib nibWithNibName:@"CustomersHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:CZCollectionElementKindSectionHeader withReuseIdentifier:@"CustomersHeaderReusableView"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:CZCollectionElementKindSectionFooter withReuseIdentifier:@"CustomersFooterReusableView"];
    
    return collectionView;
    
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

- (void)setOrderMainModel:(OrderMainModel *)orderMainModel{
    
    _orderMainModel = orderMainModel;
    
    [self reloadData];
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
    
    if(kScreenWidth < 375){
        return (kScreenWidth)/3-20;
        
    }else if (kScreenWidth > 375){
        
        return (kScreenWidth)/3-40;
        
    }else{
        return (kScreenWidth)/3-40;
    }
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth,210);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CZCollectionElementKindSectionHeader])
    {
        CustomersHeaderReusableView * customersHeaderReusableView =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CustomersHeaderReusableView" forIndexPath:indexPath];
        customersHeaderReusableView.backgroundColor = [UIColor whiteColor];
        customersHeaderReusableView.bannerArray = _orderMainModel.banner_list;
        customersHeaderReusableView.adArray = _orderMainModel.member_list;
        
        customersHeaderReusableView.clickEngineerHeaderReusableViewBlock = ^(NSString * t_id){
            
            if (_didselectItemsCustomersCollectionViewHeader_t_id_Block) {
                _didselectItemsCustomersCollectionViewHeader_t_id_Block(t_id);
            }
        };
        customersHeaderReusableView.clickEngineerHeaderReusableViewMoreBtnBlock = ^(NSString * t_id){
            if (_didselectItemsCustomersCollectionViewHeader_moreBtn_Block) {
                _didselectItemsCustomersCollectionViewHeader_moreBtn_Block(t_id);
            }
        };
        return customersHeaderReusableView;
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
    EngineerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor =[UIColor clearColor];
    
    Class_List12 * class_List12 = _dataArray[indexPath.row];
    
    cell.titleLab.text = class_List12.gc_name;
    [cell.iconImageView setImageWithUrl:class_List12.gc_image placeholder:nil];
//    cell.iconImageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DeLog(@"indexPath section: %ld  row:%ld", (long)indexPath.section, (long)indexPath.row);
    
    Class_List12 * class_List12 = _dataArray[indexPath.row];

    if (_didselectItemsCustomersCollectionViewBlock) {
        _didselectItemsCustomersCollectionViewBlock(class_List12.gc_name,class_List12.gc_id);
    }
}



@end
