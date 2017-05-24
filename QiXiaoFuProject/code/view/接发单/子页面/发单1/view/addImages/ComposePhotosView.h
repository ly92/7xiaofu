//
//  ComposePhotosView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComposePhotosView;
@protocol ComposePhotosViewDelegate <NSObject>

-(void)ComposePhotosView:(ComposePhotosView *)ComposePhotosView didSelectDeleBtnAtIndex:(NSInteger)Index;

-(void)ComposePhotosView:(ComposePhotosView *)ComposePhotosView didSelectImageAtIndex:(NSInteger)Index;

@end

@interface ComposePhotosView : UIView
@property (nonatomic,weak)id<ComposePhotosViewDelegate>delegate;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,assign)NSInteger index;




@property(nonatomic, copy) void (^composePhotosViewDidSelectDeleBtnAtIndex)(NSInteger index);

@property(nonatomic, copy) void (^composePhotosViewDidSelectImageAtIndex)(NSInteger index);


@end
