//
//  EngineerDetaileImageCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerDetaileImageCell.h"
#import "UIButton+WebCache.h"
#import "EngineerDetaileModel.h"
#import "SYPhotoBrowser.h"

@implementation EngineerDetaileImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    
//    _btn1.tag = 0;
//    [_btn1 addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
//    _btn2.tag = 1;
//    [_btn2 addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
//    _btn3.tag = 2;
//    [_btn3 addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
//    

}


- (void)setImageArray:(NSArray *)imageArray{

    _imageArray = imageArray;
    
   
    
    if (_row == 0) {
        _titleLab.hidden = NO;
        
        if (imageArray.count == 1) {
            Cer_Images * cer_Images1 =imageArray[0];
            [_btn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:cer_Images1.cer_image] forState:UIControlStateNormal placeholderImage:kDefaultImage_Z];
          
            [_btn1 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                [self btnClickAction:0];
            }];
            
        }
        if (imageArray.count ==2) {
            
            Cer_Images * cer_Images1 =imageArray[0];
            [_btn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:cer_Images1.cer_image] forState:UIControlStateNormal placeholderImage:kDefaultImage_Z];
            Cer_Images * cer_Images2 =imageArray[1];
            [_btn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:cer_Images2.cer_image] forState:UIControlStateNormal placeholderImage:kDefaultImage_Z];
            
            [_btn1 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                [self btnClickAction:0];

            }];
            [_btn2 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                [self btnClickAction:1];

            }];
            
            
        }
        if (imageArray.count >= 3) {
            
            Cer_Images * cer_Images1 =imageArray[0];
            [_btn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:cer_Images1.cer_image] forState:UIControlStateNormal placeholderImage:kDefaultImage_Z];
            Cer_Images * cer_Images2 =imageArray[1];
            [_btn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:cer_Images2.cer_image] forState:UIControlStateNormal placeholderImage:kDefaultImage_Z];
            Cer_Images * cer_Images3 =imageArray[2];
            [_btn3 sd_setBackgroundImageWithURL:[NSURL URLWithString:cer_Images3.cer_image] forState:UIControlStateNormal placeholderImage:kDefaultImage_Z];
            [_btn1 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                [self btnClickAction:0];

            }];
            [_btn2 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                [self btnClickAction:1];

            }];
            [_btn3 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                [self btnClickAction:2];

            }];
            
        }
     

    }else{
        _titleLab.hidden = YES;
        
        if (imageArray.count ==4) {
            Cer_Images * cer_Images4 =imageArray[3];
            [_btn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:cer_Images4.cer_image] forState:UIControlStateNormal placeholderImage:kDefaultImage_Z];
            [_btn1 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                [self btnClickAction:3];

            }];
        }
        
        if (imageArray.count ==5) {
            
            Cer_Images * cer_Images4 =imageArray[3];
            [_btn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:cer_Images4.cer_image] forState:UIControlStateNormal placeholderImage:kDefaultImage_Z];
            Cer_Images * cer_Images5 =imageArray[4];
            
            [_btn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:cer_Images5.cer_image] forState:UIControlStateNormal placeholderImage:kDefaultImage_Z];
            [_btn1 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                [self btnClickAction:3];

            }];
            [_btn2 tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                [self btnClickAction:4];
            }];
        }
        
    }


}


- (void)btnClickAction:(NSInteger )tag{

    
//    NSMutableArray * imgArray = [NSMutableArray new];
//    NSMutableArray * descArray = [NSMutableArray new];
//    
//    [_imageArray enumerateObjectsUsingBlock:^(Cer_Images * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [imgArray addObject:obj.cer_image];
//        [descArray addObject:obj.cer_image_name];
//    }];
//    
//    SYPhotoBrowser *browser = [[SYPhotoBrowser alloc]init];
//    browser.originalImages = imgArray;
//    browser.titles = descArray;
//    browser.currentIndex = tag;
//    browser.currentRect = CGRectMake(kScreenWidth/2, kScreenHeight/2, 0, 0);
//    [browser show];
//

}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
