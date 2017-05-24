//
//  MKMessagePhotoView.h
//
//  Created by Mory on 16/3/12.
//  Copyright © 2016年 MCWonders. All rights reserved.
//


#import "MessagePhotoView.h"


#define MaxItemCount 9
#define ItemHeight ((kScreenWidth - 60) / 5)
#define ItemWidth ((kScreenWidth - 60) / 5)
#define ItemMar 10


#define kScreenWidth   ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight   ([[UIScreen mainScreen] bounds].size.height)


@interface MessagePhotoView ()

/**
 *  这是背景滚动视图
 */
@property (nonatomic,strong) UIScrollView  *photoScrollView;
//@property (nonatomic,strong) ComposePhotosView *photoItem;
@property (nonatomic,strong) NSMutableArray *array;//展示图片数

@end


@implementation MessagePhotoView

- (id)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _array = [NSMutableArray arrayWithArray:imageArray];
        
        _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_photoScrollView];
        
        [self initlizerScrollView:_array];
    }
    return self;
}


- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    _array = [NSMutableArray arrayWithArray:imageArray];
    
    [self initlizerScrollView:_array];

}


///调用布局
-(void)initlizerScrollView:(NSArray *)imgList{

    ///移除之前添加的图片缩略图
    [self.photoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.photoScrollView removeAllSubviews];
    
    for(int i=0;i < imgList.count;i++){

      ComposePhotosView  *  _photoItem = [[ComposePhotosView alloc]initWithFrame:CGRectMake(ItemMar+ i * (ItemWidth + ItemMar ), ItemMar, ItemWidth, ItemHeight)];
        _photoItem.delegate = self;
         _photoItem.index = i;
        _photoItem.image = (UIImage *)[imgList objectAtIndex:i];
        [self.photoScrollView addSubview:_photoItem];
        
    }
    if(imgList.count<MaxItemCount){
        
        UIImageView *addPhotos =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_camera"]];
        [addPhotos setFrame:CGRectMake(ItemMar + (ItemWidth +ItemMar) * imgList.count, ItemMar, ItemWidth, ItemHeight)];
        [addPhotos setUserInteractionEnabled:YES];
        [addPhotos addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddPhotos:)]];
        [self.photoScrollView addSubview:addPhotos];
    }
    
    NSLog(@"self.frame.origin.y是:%f",self.frame.size.height);
    NSInteger count = MIN(imgList.count, MaxItemCount) + 1;
    DeLog(@"图片总数量：%ld",_array.count);
    
    
    self.photoScrollView.contentOffset=CGPointMake(0 + (ItemWidth + ItemMar)*count,ItemWidth);
    
    [self.photoScrollView setContentSize:CGSizeMake(ItemMar + (ItemWidth + ItemMar)*count, ItemWidth)];
    
    [self.photoScrollView reloadInputViews];

    
//    [self.photoScrollView scrollRectToVisible:CGRectMake(0, 0, 10000, ItemHeight) animated:YES];
    
//    CGFloat www = self.photoScrollView.contentSize.width + ItemWidth;//- self.photoScrollView.bounds.size.width;
//
////    [self.photoScrollView setContentOffset:CGPointMake( www , 0) animated:YES];
//
//    
//    [self.photoScrollView scrollRectToVisible:CGRectMake(www, 0, www, ItemHeight) animated:YES];
}

///浏览图片的代理方法
-(void)clickAddPhotos:(UITapGestureRecognizer *)gestureRecognizer{
    
     if (_photoViewDidAddPhoto) {
        _photoViewDidAddPhoto();
    }

    
}

#pragma mark - MKComposePhotosViewDelegate
///删除已选中图片并从新写入沙盒
-(void)ComposePhotosView:(ComposePhotosView *)ComposePhotosView didSelectDeleBtnAtIndex:(NSInteger)Index{
    
    [_array removeObjectAtIndex:Index];
    [self initlizerScrollView:_array];
    NSLog(@"删除了第%ld张",(long)Index);
    
    if (_photoViewDidDeletePhotoAtIndex) {
        _photoViewDidDeletePhotoAtIndex(Index);
    }
}

///图片浏览的 delegate 方法
-(void)ComposePhotosView:(ComposePhotosView *)ComposePhotosView didSelectImageAtIndex:(NSInteger)Index{
    
    NSLog(@"点击了第%lu个",Index);

    if (_photoViewDidSelectePhotoAtIndex) {
        _photoViewDidSelectePhotoAtIndex(Index,_array[Index]);
    }    
}





@end
