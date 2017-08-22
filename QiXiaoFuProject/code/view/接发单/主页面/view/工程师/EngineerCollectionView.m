//
//  EngineerCollectionView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerCollectionView.h"
#import "PDCollectionViewFlowLayout.h"
#import "EngineerHeaderReusableView.h"
#import "EngineerCell.h"
#import "OrderMainModel.h"


static NSString *identifier = @"EngineerCell";


@interface EngineerCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate,PDCollectionViewFlowLayoutDelegate>{
    

    
}


@end


@implementation EngineerCollectionView
+ (EngineerCollectionView *)engineerCollectionView{

    
    
    PDCollectionViewFlowLayout * layout = [[PDCollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    //    layout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.columnCount = 3;
    
    
    EngineerCollectionView * collectionView = [[EngineerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = RGB(247, 247, 247);
    
    //    UIEdgeInsets insets = {top, left, bottom, right};
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"EngineerCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    [collectionView registerNib:[UINib nibWithNibName:@"EngineerHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:CZCollectionElementKindSectionHeader withReuseIdentifier:@"EngineerHeaderReusableView"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:CZCollectionElementKindSectionFooter withReuseIdentifier:@"EngineerFooterReusableView"];
    
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
        EngineerHeaderReusableView * engineerHeaderReusableView =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"EngineerHeaderReusableView" forIndexPath:indexPath];
        engineerHeaderReusableView.backgroundColor = [UIColor whiteColor];
        engineerHeaderReusableView.bannerArray = _orderMainModel.eng_banner_list;
        engineerHeaderReusableView.adArray = _orderMainModel.bill_list;

        
        engineerHeaderReusableView.clickEngineerHeaderReusableViewBlock = ^(NSString * t_id){
             if (_didselectItemsEngineerCollectionViewHeader_t_id_Block) {
                _didselectItemsEngineerCollectionViewHeader_t_id_Block(t_id);
            }
         };
        engineerHeaderReusableView.clickEngineerHeaderReusableViewMoreBtnBlock = ^(NSString * t_id){
            if (_didselectItemsEngineerCollectionViewHeader_moreBtn_Block) {
                _didselectItemsEngineerCollectionViewHeader_moreBtn_Block();
            }
        };
        return engineerHeaderReusableView;
    }
    else if ([kind isEqualToString:CZCollectionElementKindSectionFooter])
    {
        UICollectionReusableView * engineerFooterReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"EngineerFooterReusableView" forIndexPath:indexPath];
          engineerFooterReusableView.backgroundColor = [UIColor whiteColor];
        return engineerFooterReusableView;
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

    if (_didselectItemsEngineerCollectionViewBlock) {
        _didselectItemsEngineerCollectionViewBlock(class_List12.gc_name,class_List12.gc_id,class_List12.list);
    }
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
