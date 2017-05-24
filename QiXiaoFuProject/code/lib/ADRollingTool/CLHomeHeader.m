//
//  CLHomeHeader.m
//  CLZhongZi
//
//  Created by darren on 16/3/7.
//  Copyright © 2016年 shanku. All rights reserved.
//

#define CLMaxSections 100
#import "OrderMainModel.h"

#import "CLHomeHeader.h"
#import "CLAdCollectionCell.h"

@interface CLHomeHeader()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) UICollectionView *collectionView;

/***/
@property (nonatomic,weak) UIImageView *placehoder;

@end

@implementation CLHomeHeader

static NSString *ADID = @"adCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        lineView1.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        [self addSubview:lineView1];
        
        
        UIView * vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
        [self addSubview:vi];

        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        
        UIImage * image = [UIImage imageNamed:@"img_xiao7"];
        imgView.image = image;
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        imgView.clipsToBounds = YES;
        [vi addSubview:imgView];
        [imgView sizeToFit];
        imgView.center = CGPointMake(50, 30);
        
        UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(kScreenWidth-50, 0, 50, 60);
        [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:moreBtn];

        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-61, 15, 1, 20)];
        lineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        [self addSubview:lineView];

        
        
    }
    return self;
}
//- (NSArray *)newses
//{
//    if (_newses == nil) {
//        self.newses = [NSArray array];
//    }
//    return _newses;
//}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 创建滚动视图
    [self setupCollectionView];
    [self.placehoder removeFromSuperview];

}


- (void)setNewses:(NSArray *)newses{

    _newses = newses;
    if (newses.count > 1) {
        
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:CLMaxSections/2] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
         [self addTimer];

    }
    [self.collectionView reloadData];


}

/*创建自动滚动视图*/
- (void)setupCollectionView
{
    // 创建collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(100, 2,kScreenWidth-100 - 51, 60-2) collectionViewLayout:layout];
    layout.itemSize = CGSizeMake(kScreenWidth-100 - 51, 60);
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
     [self addSubview:collectionView];
    self.collectionView = collectionView;

    // 注册cell
    [self.collectionView registerClass:[CLAdCollectionCell class] forCellWithReuseIdentifier:ADID];
    // 默认显示最中间的那组
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:CLMaxSections/2] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    
    
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (NSIndexPath *)resetIndexPath
{
    // 当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    // 马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:CLMaxSections/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    return currentIndexPathReset;
}

/**
 *  下一页
 */
- (void)nextPage
{
    // 1.马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
    
    // 2.计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.newses.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    // 3.通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _newses.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return CLMaxSections;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CLAdCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADID forIndexPath:indexPath];
    
    Bill_List * bill_List =self.newses[indexPath.row];
    cell.lableContent1.text =bill_List.title;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    Bill_List * bill_List =self.newses[indexPath.row];

    if (_clickCellBlock) {
        _clickCellBlock(bill_List.id);
    }
    
}

- (void)moreBtnAction:(UIButton *)btn{

    if (_clickCellMoreBtnBlock) {
        _clickCellMoreBtnBlock(@"");
    }
    


}



#pragma mark  - UICollectionViewDelegate
/**
 *  当用户即将开始拖拽的时候就调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

/**
 *  当用户停止拖拽的时候就调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
@end
