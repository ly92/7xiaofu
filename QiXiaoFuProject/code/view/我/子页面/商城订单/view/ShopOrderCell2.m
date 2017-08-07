//
//  ShopOrderCell2.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/8/7.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "ShopOrderCell2.h"
#import "ShopOrderCell2Cell.h"
#import "ShopOrderModel.h"


@interface ShopOrderCell2 ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ShopOrderCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShopOrderCell2Cell" bundle:nil] forCellWithReuseIdentifier:@"ShopOrderCell2Cell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.iconArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShopOrderCell2Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopOrderCell2Cell" forIndexPath:indexPath];
    if (self.iconArray.count > indexPath.row){
        Order_List *model = self.iconArray[indexPath.row];
        [cell.iconImgV setImageWithUrl:model.goods_image placeholder:kDefaultImage_Z];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 60);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}



@end
