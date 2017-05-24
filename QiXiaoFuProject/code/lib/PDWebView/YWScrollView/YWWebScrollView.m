//
//  YWWebScrollView.m
//  SmallLook
//
//  Created by NeiQuan on 16/6/24.
//  Copyright © 2016年 余伟. All rights reserved.
//

#import "YWWebScrollView.h"
#import "UIImageView+WebCache.h"
@interface YWWebScrollView ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    NSInteger   m_iCurrentPage;
    
}
@end
@implementation YWWebScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    
 if (self=[ super initWithFrame:frame])
  {
     [self setBackgroundColor:[ UIColor blackColor]];
      m_iCurrentPage=0;
  }
    
  return self;
    
}
#pragma mark --private method--初始化scrollView
-(void)setImageUrls:(NSMutableArray *)imageUrls{
    
    _imageUrls=imageUrls;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.tag=5000;
    scrollView.delegate=self;
    scrollView.frame = self.frame;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*self.imageUrls.count, 0);
    scrollView.pagingEnabled = YES;
    for (NSInteger i = 0; i<self.imageUrls.count; i++) {
        YWWebSmallScrollView *view=[[ YWWebSmallScrollView alloc] initWithFrame: CGRectMake(i*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        view.tag=100+i;
        [view StartLoadImageWithUrl:_imageUrls[i]];
        view .CancleShow=^{
            
            [self clickImageView];//点击图片移除视图
        };
        [scrollView addSubview:view];
    }
    [self addSubview:scrollView];
    _scrollView =scrollView;
    scrollView.contentOffset=CGPointMake(_ScrollViewTag*scrollView.frame.size.width, 0);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.center=window.center;
        [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
       
    } completion:^(BOOL finished) {
        
        self.alpha = 1.0;

    }];
    [window addSubview:self];
}
-(void)clickImageView{
        
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.1;
            self.transform  = CGAffineTransformMakeScale(1.3, 1.3);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            
        }];
//    });

}
#pragma mark -- UIScrollViewDelegate method
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger iCurrentPage = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    if (iCurrentPage != m_iCurrentPage)
    {
        YWWebSmallScrollView *pZoomView = (YWWebSmallScrollView *)[scrollView viewWithTag:100 + m_iCurrentPage];
        [pZoomView RestoreViewScale];
        m_iCurrentPage = iCurrentPage;
    }
}

@end


@interface YWWebSmallScrollView()<UIScrollViewDelegate,UIActionSheetDelegate>
{
    UIImageView *m_pImageView;
    UIActivityIndicatorView *m_pActivityIndicatorV;
}

@end
@implementation YWWebSmallScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 3.0f;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.directionalLockEnabled = YES;
        self.delegate = self;
        //添加单击取消事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CancelReviewImage)];
        [self addGestureRecognizer:singleTap];
        //添加双击事件
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomInOrOut:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        //约束单击和双击不能同时生效
        [singleTap requireGestureRecognizerToFail:doubleTap];
        //添加长按保存图片事件
        UILongPressGestureRecognizer *pSaveImage = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(SaveImageToAlbum:)];
        [self addGestureRecognizer:pSaveImage];
        //添加图片加载指示器
        
        
        m_pActivityIndicatorV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        m_pActivityIndicatorV.frame = CGRectMake(0, 0, 0 , 0);
        m_pActivityIndicatorV.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        [self addSubview:m_pActivityIndicatorV];
        
        m_pImageView=[[ UIImageView alloc] init];
        m_pImageView.contentMode=UIViewContentModeScaleAspectFit;
//        m_pImageView.clipsToBounds=YES;
        [self addSubview:m_pImageView];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGRect fScreenBounds = [[UIScreen mainScreen] bounds];
    CGRect fFrame = CGRectMake(frame.origin.x, frame.origin.y, fScreenBounds.size.width, fScreenBounds.size.height);
    [super setFrame:fFrame];
}

- (void)RestoreViewScale
{
    if (self.zoomScale != 1.0f)
    {
        [self setZoomScale:1.0f animated:NO];
    }
}

- (void)StartLoadImageWithUrl:(NSString *)url
{
    if ([url isEqualToString:@""] || url == nil)
        return;
    [m_pActivityIndicatorV startAnimating];
    __weak typeof(self) weakSelf = self;
    __block typeof(m_pActivityIndicatorV) pActivityIndicatorV = m_pActivityIndicatorV;
    __weak typeof(m_pImageView) weakImageView = m_pImageView;
    [m_pImageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakImageView.image = image;
        [weakSelf RestImageViewFrame];
        [pActivityIndicatorV stopAnimating];
    }];
}


#pragma mark -- private method
- (void)RestImageViewFrame;
{
//    //等比例缩放
//    if (!m_pImageView)return;
//    
//    CGSize size = (m_pImageView.image) ? m_pImageView.image.size : m_pImageView.frame.size;
//    CGFloat fWidth = 0.0,fHeight = 0.0;
//    if ((size.width >= self.frame.size.width || size.height >= self.frame.size.height) && (size.height / size.width <= 2.0f && size.width / size.height <= 2.0f))
//    {
//        //设置图片的高与屏幕相等
//        if (size.height * (self.frame.size.width / size.width) > self.frame.size.height)
//        {
//            fHeight = self.frame.size.height;
//            fWidth = size.width * fHeight / size.height;
//        }
//        else
//        {
//            fWidth = self.frame.size.width;
//            fHeight = fWidth * size.height / size.width;
//        }
//    }
//    else
//    {
//        fWidth = size.width;
//        fHeight = size.height;
//        if (size.height / size.width > 2.0f)
//        {
//            if (size.width > self.frame.size.width / 3.0f)
//            {
//                fWidth = self.frame.size.width / 3.0f;
//                fHeight = fWidth * size.height / size.width;
//            }
//        }
//        else if (size.width / size.height > 2.0f)
//        {
//            if (size.height > self.frame.size.height / 3.0f)
//            {
//                fHeight = self.frame.size.height / 3.0f;
//                fWidth = size.width * fHeight / size.height;
//            }
//        }
//    }
//    
//    
//    if (size.height / size.width > 2.0f)
//    {
//        CGFloat yMargin = fHeight > self.frame.size.height ? 0.0f : (self.frame.size.height - fHeight) / 2.0f;
//        m_pImageView.frame = CGRectMake((self.frame.size.width - fWidth) / 2.0f, yMargin, fWidth, fHeight);
//        if (yMargin == 0.0f)
//        {
//            [self setZoomScale:3.0f animated:NO];
//            [self setZoomScale:1.0f animated:NO];
//            [self setContentOffset:CGPointMake(self.contentOffset.x, 0.0f)];
//        }
//    }
//    else if (size.width / size.height > 2.0f)
//    {
//        CGFloat xMargin = fWidth > self.frame.size.width ? 0.0f : (self.frame.size.width - fWidth) / 2.0f;
//        m_pImageView.frame = CGRectMake(xMargin, (self.frame.size.height - fHeight) / 2.0f, fWidth, fHeight);
//        if (xMargin == 0.0f)
//        {
//            [self setZoomScale:3.0f animated:NO];
//            [self setZoomScale:1.0f animated:NO];
//            [self setContentOffset:CGPointMake(0.0f, self.contentOffset.y)];
//        }
//    }
//    else
//    {
//        m_pImageView.frame = CGRectMake((self.frame.size.width - fWidth) / 2.0f, (self.frame.size.height - fHeight) / 2.0f, fWidth, fHeight);
//    }
//   
    m_pImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    
}

#pragma mark -- UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return m_pImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = self.frame.size.width - self.contentInset.left - self.contentInset.right;
    CGFloat Hs = self.frame.size.height - self.contentInset.top - self.contentInset.bottom;
    CGFloat W = m_pImageView.frame.size.width;
    CGFloat H = m_pImageView.frame.size.height;
    
    CGRect rct = m_pImageView.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    m_pImageView.frame = rct;
}



#pragma mark -- long press gesture method
- (void)SaveImageToAlbum:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *pActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片到相册", nil];
        [pActionSheet showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(m_pImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDictionary objectForKey:@"CFBundleName"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存图片被阻止了" message:[NSString stringWithFormat:@"请到系统->“设置”->“隐私”->“照片”中开启“%@”访问权限",appName] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已保存至照片库"delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] ;
        [alertView show];
    }
}

#pragma mark -- single tap gesture method
- (void)CancelReviewImage
{
    self.backgroundColor = [UIColor clearColor];
    if (self.CancleShow)
    {
         self.CancleShow();
    }
  
}

#pragma mark -- double tap gesture method
- (void)zoomInOrOut:(UITapGestureRecognizer *)tapGesture
{
    if (self.zoomScale == self.minimumZoomScale)
    {
        CGPoint point = [tapGesture locationInView:self];
        [self zoomToRect:CGRectMake(point.x - 24, point.y - 24 , 48, 48) animated:YES];
    }
    else
    {
        [self setZoomScale:1.0f animated:YES];
    }
}


@end
