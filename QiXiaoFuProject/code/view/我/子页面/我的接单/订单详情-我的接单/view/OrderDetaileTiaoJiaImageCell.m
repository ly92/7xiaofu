//
//  OrderDetaileTiaoJiaImageCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderDetaileTiaoJiaImageCell.h"
#import "SYPhotoBrowser.h"

@interface OrderDetaileTiaoJiaImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;

@end


@implementation OrderDetaileTiaoJiaImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapaction:)];
    [_imageView1 addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapaction1:)];
    [_imageView2 addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapaction2:)];
    [_imageView3 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapaction3:)];
    [_imageView4 addGestureRecognizer:tap3];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapaction4:)];
    [_imageView5 addGestureRecognizer:tap4];
    
    // Initialization code
}


- (void)setImageArray:(NSArray *)imageArray{

    _imageArray = imageArray;
    
    if (imageArray.count ==1) {
        [_imageView1 setImageWithUrl:imageArray[0] placeholder:kDefaultImage_Z];
        _imageView1.userInteractionEnabled = YES;
    }else  if (imageArray.count ==2) {
        [_imageView1 setImageWithUrl:imageArray[0] placeholder:kDefaultImage_Z];
        [_imageView2 setImageWithUrl:imageArray[1] placeholder:kDefaultImage_Z];
        _imageView1.userInteractionEnabled = YES;
        _imageView2.userInteractionEnabled = YES;

        
    }else if (imageArray.count ==3){
        [_imageView1 setImageWithUrl:imageArray[0] placeholder:kDefaultImage_Z];
        [_imageView2 setImageWithUrl:imageArray[1] placeholder:kDefaultImage_Z];
        [_imageView3 setImageWithUrl:imageArray[2] placeholder:kDefaultImage_Z];
        _imageView1.userInteractionEnabled = YES;
        _imageView2.userInteractionEnabled = YES;
        _imageView3.userInteractionEnabled = YES;

        
    }else if (imageArray.count ==4){
        [_imageView1 setImageWithUrl:imageArray[0] placeholder:kDefaultImage_Z];
        [_imageView2 setImageWithUrl:imageArray[1] placeholder:kDefaultImage_Z];
        [_imageView3 setImageWithUrl:imageArray[2] placeholder:kDefaultImage_Z];
        [_imageView4 setImageWithUrl:imageArray[3] placeholder:kDefaultImage_Z];
        _imageView1.userInteractionEnabled = YES;
        _imageView2.userInteractionEnabled = YES;
        _imageView3.userInteractionEnabled = YES;
        _imageView4.userInteractionEnabled = YES;


    }else if (imageArray.count ==5){
        [_imageView1 setImageWithUrl:imageArray[0] placeholder:kDefaultImage_Z];
        [_imageView2 setImageWithUrl:imageArray[1] placeholder:kDefaultImage_Z];
        [_imageView3 setImageWithUrl:imageArray[2] placeholder:kDefaultImage_Z];
        [_imageView4 setImageWithUrl:imageArray[3] placeholder:kDefaultImage_Z];
        [_imageView5 setImageWithUrl:imageArray[4] placeholder:kDefaultImage_Z];
        _imageView1.userInteractionEnabled = YES;
        _imageView2.userInteractionEnabled = YES;
        _imageView3.userInteractionEnabled = YES;
        _imageView4.userInteractionEnabled = YES;
        _imageView5.userInteractionEnabled = YES;

    }
    
}




- (void)tapaction:(UITapGestureRecognizer *)tap{
    [self showImageForIndex:0];
}
- (void)tapaction1:(UITapGestureRecognizer *)tap{
    [self showImageForIndex:1];
}
- (void)tapaction2:(UITapGestureRecognizer *)tap{
    [self showImageForIndex:2];
}
- (void)tapaction3:(UITapGestureRecognizer *)tap{
    [self showImageForIndex:3];
}
- (void)tapaction4:(UITapGestureRecognizer *)tap{
    [self showImageForIndex:4];
}




/**
 点击图片查看大图

 @param index 图片索引
 */
- (void)showImageForIndex:(NSInteger )index{


    SYPhotoBrowser *browser = [[SYPhotoBrowser alloc]init];
    browser.originalImages = _imageArray;
    browser.currentIndex = index;
    browser.currentRect = CGRectMake(kScreenWidth/2, kScreenHeight/2, 0, 0);
    [browser show];


}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
