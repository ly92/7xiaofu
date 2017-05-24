//
//  YWWebScrollView.h
//  SmallLook
//
//  Created by NeiQuan on 16/6/24.
//  Copyright © 2016年 余伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWWebScrollView : UIView
@property (nonatomic, strong) NSMutableArray *imageUrls;

@property(nonatomic,assign)NSInteger ScrollViewTag;//用于记录点击那个照片



@end

@interface YWWebSmallScrollView : UIScrollView

/**
 *  单击取消图片浏览器的操作
 */
@property(nonatomic,copy)void (^CancleShow)();


/**
 *  恢复item的初始缩放比例
 */
- (void)RestoreViewScale;

/**
 *  开始加载视图操作
 *
 *  @param url 加载image的URL
 */
- (void)StartLoadImageWithUrl:(NSString *)url;


@end
