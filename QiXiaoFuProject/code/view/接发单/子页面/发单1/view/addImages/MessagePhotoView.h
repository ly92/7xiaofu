//
//  MKMessagePhotoView.h
//
//  Created by Mory on 16/3/12.
//  Copyright © 2016年 MCWonders. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "ComposePhotosView.h"

#define kZBMessageShareMenuPageControlHeight 30

@class MessagePhotoView;
@protocol MessagePhotoViewDelegate <NSObject>

@optional
- (void)didSelectePhotoMenuItem:(ComposePhotosView *)shareMenuItem atIndex:(NSInteger)index;

-(void)addPicker:(id )picker;          //UIImagePickerController
-(void)addUIImagePicker:(UIImagePickerController *)picker;

@end

@interface MessagePhotoView : UIView<UIActionSheetDelegate,UIScrollViewDelegate,ComposePhotosViewDelegate>{
    
}
@property(nonatomic,strong) UIScrollView *scrollview;

@property (nonatomic, weak) id <MessagePhotoViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageArray;

/** 需要展示的图片数据*/
@property(nonatomic,strong) NSArray * imageArray;





@property(nonatomic, copy) void (^photoViewDidSelectePhotoAtIndex)(NSInteger index,UIImage * selectImahe);
@property(nonatomic, copy) void (^photoViewDidAddPhoto)();
@property(nonatomic, copy) void (^photoViewDidDeletePhotoAtIndex)(NSInteger index);



@end
