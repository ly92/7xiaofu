//
//  ComposePhotosView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 fhj. All rights reserved.
//


#import "ComposePhotosView.h"


@interface ComposePhotosView (){

    CGFloat  _itemWidth;
    CGFloat  _itemHeight;

}

@end

@implementation ComposePhotosView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _itemWidth = frame.size.width;
        _itemHeight = frame.size.height;
        // Initialization code
    }
    return self;
}


-(void)setImage:(UIImage *)image
{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _itemWidth, _itemHeight)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor =[UIColor grayColor].CGColor;
    imageView.image = image;
    imageView.tag = self.index;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    [self addSubview:imageView];
    
    
    
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.frame = CGRectMake(imageView.frame.size.width - 15, 0, 15, 15);
    [btnDelete setImage:[UIImage imageNamed:@"car_certification_icon_shanchu"] forState:UIControlStateNormal];
    btnDelete.tag = self.index;
    [btnDelete addTarget:self
                  action:@selector(deletePhotoItem:)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDelete];
 
}

///删除图片的代理方法
-(void)deletePhotoItem:(UIButton *)btn{

    if ([self.delegate respondsToSelector:@selector(ComposePhotosView:didSelectDeleBtnAtIndex:)]) {
        [self.delegate ComposePhotosView:self didSelectDeleBtnAtIndex:btn.tag];
    }
    if(_composePhotosViewDidSelectDeleBtnAtIndex){
        _composePhotosViewDidSelectDeleBtnAtIndex(btn.tag);
    }
}


///浏览图片的代理方法
-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer{

//    追溯图片属性
    UIView *viewClicked = [gestureRecognizer view];
    if ([self.delegate respondsToSelector:@selector(ComposePhotosView:didSelectImageAtIndex:)]) {
        [self.delegate ComposePhotosView:self didSelectImageAtIndex:viewClicked.tag];
    }
    if(_composePhotosViewDidSelectImageAtIndex){
      _composePhotosViewDidSelectImageAtIndex(viewClicked.tag);
    }
    
    
}

@end
