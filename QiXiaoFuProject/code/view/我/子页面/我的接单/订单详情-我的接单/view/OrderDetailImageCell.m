//
//  OrderDetailImageCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderDetailImageCell.h"
#import "SYPhotoBrowser.h"
#import "QXFUITapGestureRecognizer.h"

@implementation OrderDetailImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat imageWidth = (kScreenWidth - 20 - 20)/3;
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth - 20,imageWidth)];
    [_bgView addSubview:_scrollview];
    // Initialization code
}

- (void)setImageArray:(NSArray *)imageArray{

    _imageArray = imageArray;
    
    if (imageArray.count ==0) {
        return;
    }
    
    CGFloat imageWidth = (kScreenWidth - 20 - 20)/3;

    for (NSInteger i = 0; i < _imageArray.count; i  ++) {
        UIImageView * ImageView = [[UIImageView alloc]initWithFrame:CGRectMake( i * imageWidth + 10 * i, 0, imageWidth, imageWidth)];
        ImageView.tag = i;
        ImageView.userInteractionEnabled = YES;
        [ImageView setImageWithUrl:imageArray[i] placeholder:kDefaultImage_Z];
        QXFUITapGestureRecognizer * tap = [[QXFUITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapaction:)];
        tap.tag = i;
        [ImageView addGestureRecognizer:tap];
        [_scrollview addSubview:ImageView];
    }
    _scrollview.contentSize = CGSizeMake(imageWidth * _imageArray.count + 10 * _imageArray.count - 10, 0);
    
}

- (void)tapaction:(QXFUITapGestureRecognizer *)tap{
    SYPhotoBrowser *browser = [[SYPhotoBrowser alloc]init];
    browser.originalImages = _imageArray;
    browser.currentIndex = tap.tag;
    browser.currentRect = CGRectMake(kScreenWidth/2, kScreenHeight/2, 0, 0);
    [browser show];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
