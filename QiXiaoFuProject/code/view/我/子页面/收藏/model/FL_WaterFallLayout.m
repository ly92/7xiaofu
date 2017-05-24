//
//  FL_WaterFallLayout.m
//  瀑布流
//
//  Created by ln on 15/11/4.
//  Copyright © 2015年 fancyLi. All rights reserved.
//

#import "FL_WaterFallLayout.h"


@interface FL_WaterFallLayout ()

@property (nonatomic, strong) NSMutableDictionary *maxYDict;
//存放布局属性
@property (nonatomic, strong) NSMutableArray *attrsArr;

@end

@implementation FL_WaterFallLayout

-(instancetype)init{
    
    if ([super init]) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.columnCount = 2;
    }
    return self;
}

-(NSMutableDictionary *)maxYDict{
    if (!_maxYDict) {
        _maxYDict = [NSMutableDictionary dictionary];
        for (int i = 0; i < self.columnCount; i++) {
            NSString *column = [NSString stringWithFormat:@"%d",i];
            self.maxYDict[column] = @"0";
        }
    }
    return _maxYDict;
}

-(NSMutableArray *)attrsArr{
    if (!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    return _attrsArr;
}
#pragma mark 以下方法每次滑动都会重新调用
-(void)prepareLayout{

    for (int i = 0; i < self.columnCount; i++) {
        NSString *column = [NSString stringWithFormat:@"%d",i];
        self.maxYDict[column] = @(self.sectionInset.top);
    }
    [self.attrsArr removeAllObjects];
    
    //1.查看共有多少个元素
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //2.遍历每个item属性
    for (int i = 0; i < count; i++) {
        
        //3.取出布局属性
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        //4.添加到书数组中
        [self.attrsArr addObject:attr];
    }
   
}

//设置允许每个collectView的content的 宽 、高
//这个方法会被调用两次 prepareLayout方法后调用一次 layoutAttributesForElementsInRect:方法后会再调用一次

-(CGSize)collectionViewContentSize{
   __block NSString *maxColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * stop) {
        if ([maxY floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue] + self.sectionInset.bottom);
    
    
}
//允许重新查找集合视图的布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
/**
 *  在这个方法里实现布局
 *
 *  @param indexPath 指定的为位置
 *
 *  @return  返回layout attributes 的实例
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

  __block NSString *miniColumn = @"0";
 [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * stop) {
     if ([maxY floatValue] < [self.maxYDict[miniColumn] floatValue]) {
         miniColumn = column;
     }
     
 }];
    
    //计算frame
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right - self.columnMargin * (self.columnCount - 1))/self.columnCount;
    CGFloat height = [self.delegate waterFlowLayout:self heightForWidth:width indexPath:indexPath];
    CGFloat x = self.sectionInset.left + (width + self.columnMargin)*[miniColumn intValue];
    CGFloat y = [self.maxYDict[miniColumn] floatValue] + self.rowMargin;
    self.maxYDict[miniColumn] = @(height + y);
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(x, y, width, height);
    
 
    return attr;
}

//设置每个 cell的大小及位置
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    return self.attrsArr;
}
@end
