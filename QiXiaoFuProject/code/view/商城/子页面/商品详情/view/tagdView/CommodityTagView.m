//
//  CommodityTagView.m
//  CommodityTag
//
//  Created by caijunrong on 15/10/23.
//  Copyright © 2015年 caijunrong. All rights reserved.
//

#import "CommodityTagView.h"
#import "NSString+Extension.h"
#import "TagModel.h"
#import "TagCell.h"

#define fontSize 12
#define HorizontalMargin 5
#define margin 8

#define cellHeight 25

@interface CommodityTagView ()
{
    CGFloat _viewHeight;

}


@end

@implementation CommodityTagView

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

//确定view的大小
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)initCommodityModelArray:(NSArray *)commArray{
    for (CommodityModel *commModel in commArray) {
        [self initTagWidth:commModel];
    }
}

- (void)initTagWidth:(CommodityModel *)commModel{
    //
    
    CGFloat _dataWidth = 0;
    CGSize maxSize = CGSizeMake((self.frame.size.width - HorizontalMargin*2 - margin*2), MAXFLOAT);
    for (TagModel *tagmodel in _tagModelArray) {
        CGSize realSize = [[NSString alloc]sizeWithText:tagmodel.tagName font:[UIFont systemFontOfSize:fontSize] maxSize:maxSize];
        
//        if (realSize.width > maxSize.width) {
//            tagmodel.tagWidth = maxSize.width;
//        }else{
        tagmodel.tagWidth = realSize.width;
        
        _dataWidth = _dataWidth + (tagmodel.tagWidth +HorizontalMargin );
        
//        }
    }
    
    CGFloat number = _dataWidth / kScreenWidth;
    _viewHeight = 40;
    if (number > 1) {
        
        _viewHeight =  30 * (number + 1);
 
    }else if (number > 2){
        _viewHeight=  35 * (number + 2);
        
    }else if (number > 3){
            _viewHeight=  35 * (number + 3);
     }else{
        _viewHeight = 35 ;
    }
}

//初始化collectionView
-(void)initCollectionViewWithModel:(NSArray *)tagModelArray{
    
    self.tagModelArray = tagModelArray;
    
    //先把宽度算好
    [self initCommodityModelArray:tagModelArray];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    //修改
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = HorizontalMargin;
    // {top, left, bottom, right};
    flowLayout.sectionInset = UIEdgeInsetsMake(HorizontalMargin, HorizontalMargin, HorizontalMargin, 0);
    
    UICollectionView *myCollectionView;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _viewHeight) collectionViewLayout:flowLayout];
    
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.showsHorizontalScrollIndicator = NO;
    myCollectionView.backgroundColor = [UIColor whiteColor];
    myCollectionView.showsVerticalScrollIndicator = NO;
    myCollectionView.scrollEnabled = NO;
    [myCollectionView registerNib:[UINib nibWithNibName:@"TagCell" bundle:nil] forCellWithReuseIdentifier:@"TagCell"];
    [self addSubview:myCollectionView];
    self.collectionView = myCollectionView;
 
    self.height =_viewHeight;
    
    
}

#pragma mark -- CollectionView delegate & dataSource
//cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TagModel *tagmodel = _tagModelArray[indexPath.row];
    
//    NSLog(@"section:%ld,row:%ld",indexPath.section,indexPath.row);
//    NSLog(@"tagmodel.tagWidth:%f",tagmodel.tagWidth);
    return CGSizeMake(tagmodel.tagWidth + margin*2,cellHeight);

}

//组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    NSLog(@"%ld",self.commodityModelArray.count);
    return 1;
}

//列
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _tagModelArray.count;
}

//cell样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TagCell *cell = [TagCell cellWithCollectionView:collectionView andIndexPath:indexPath];
    
     TagModel *tagmodel = _tagModelArray[indexPath.row];
    
    cell.tagLabel.text = tagmodel.tagName;
    [cell setBackgroundColor:kThemeColor];
    [cell.tagLabel setTextColor:[UIColor whiteColor]];
    CGColorRef cgcolor = [UIColor groupTableViewBackgroundColor].CGColor;
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBorderColor:cgcolor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
