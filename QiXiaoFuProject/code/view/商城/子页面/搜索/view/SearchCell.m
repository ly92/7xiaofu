
//
//  SearchCell.m
//  BeautifulFaceProject
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "SearchCell.h"
@interface SearchCell ()
@property (nonatomic, strong) UIImageView *iconImageView;

@end
@implementation SearchCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    return self;
}

- (void)addViews{
 
    
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.enabled = NO;
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [_titleBtn setBackgroundImage:[UIImage imageNamed:@"filter_s"] forState:UIControlStateHighlighted];
    [_titleBtn setTitleColor:kBackgroundColor forState:UIControlStateHighlighted];
//    [_titleBtn setBackgroundImage:[UIImage imageNamed:@"filter_n"] forState:UIControlStateNormal];
    [_titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:_titleBtn];


    
    _titleBtn.layer.cornerRadius =  15;
    _titleBtn.clipsToBounds = YES;
    _titleBtn.layer.borderColor =[UIColor grayColor].CGColor;
    _titleBtn.layer.borderWidth =1;
    
    
    
}


/**
 *  在这里可以布局contentView里面的控件
 *
 *  @param layoutAttributes 直接继承于NSObject 形式上类似于CALayer
 */
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
//    _iconImageView.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.width);
//    
//    CGFloat labH =(layoutAttributes.frame.size.height - layoutAttributes.frame.size.width)/2;
//    CGFloat mar = kRatio(20);
    
    _titleBtn.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height);
 
    
    
}

@end
