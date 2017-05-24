//
//  ZLCWebView.m
//  测试
//
//  Created by shining3d on 16/6/17.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import "PDWebView.h"
#import "Html5Utils.h"
#import "YWWebScrollView.h"


@interface PDWebView ()<UIAlertViewDelegate>
{
    UIWebView *_ywebView;
    NSMutableArray *_imageArray; //用于保存图片链接
    
}
@property (nonatomic, strong) NSTimer *fakeProgressTimer;
@property (nonatomic, assign) BOOL uiWebViewIsLoading;
@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;
@property (nonatomic, strong) NSURL *URLToLaunchWithPermission;
@property (nonatomic, strong) UIAlertView *externalAppPermissionAlertView;

// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;
@end


@implementation PDWebView

#pragma mark --Initializers
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWebViewWithFrame:frame];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initWebViewWithFrame:self.frame];
    }
    return self;
}


- (void)initWebViewWithFrame:(CGRect)frame{
    
    
    self.frame = frame;
    
    _imageArray=[[ NSMutableArray alloc] init];
    //        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self setDelegate:self];
    [self setMultipleTouchEnabled:YES];
    [self setAutoresizesSubviews:YES];
    [self setScalesPageToFit:YES];
    [self.scrollView setAlwaysBounceVertical:YES];
    self.scrollView.bounces = YES;
    
    
    _showImage = NO;
    _safariOpenUrl = NO;

}



#pragma mark - Public Interface
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.progressView setTintColor:tintColor];
}
- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
}

- (void)setProgressViewOffset:(CGFloat)progressViewOffset{
     [self.progressView setFrame:CGRectMake(0, progressViewOffset, self.frame.size.width, self.progressView.frame.size.height)];
 
}

- (void)setShowProgress:(BOOL)showProgress{

    _showProgress = showProgress;
    if (_showProgress) {
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        [self.progressView setFrame:CGRectMake(0, 0, self.frame.size.width, self.progressView.frame.size.height)];
        //设置进度条颜色
        [self setTintColor:[UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
        [self addSubview:self.progressView];
     }
}



- (void)setShowImage:(BOOL)showImage{
     if (showImage) {
        _safariOpenUrl = NO;
    }
    _showImage = showImage;
}
- (void)setSafariOpenUrl:(BOOL)safariOpenUrl{
    if (safariOpenUrl) {
        _showImage = NO;
    }
     _safariOpenUrl = safariOpenUrl;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}
//监视请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (_showImage) {
        return  [self clickimageWithWebView:webView WithRequest:request navigationType:navigationType];
    }
    if (_safariOpenUrl) {
        return [self webViewWithSafariOpenUrlWithWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self autoImageSizeToScreenSizeWithWebView:webView];
    
    if (_showImage) {
        [self webViewShowImagePhotoBrowerWithWebView:webView];
    }
    
    if(!self.isLoading) {
        self.uiWebViewIsLoading = NO;
        
        [self fakeProgressBarStopLoading];
    }
    
    
}

/**
 *  给图片添加点击方法
 *
 *  @param webview webview
 */

- (void)webViewShowImagePhotoBrowerWithWebView:(UIWebView *)webview{
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    [webview stringByEvaluatingJavaScriptFromString:js];
    [webview stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    [webview  stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];//静止用户选择
    [webview stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout=‘none‘;"];//静止长按
    [webview addClickEventOnImg];//有的图片没有点击事件
    _imageArray= [webview   getImgs];//获取所有图片链接
    NSMutableArray *array=[[ NSMutableArray alloc] init];
    for (NSString *string in _imageArray) //剔除没有规则的图集
    {
        //        if ([string hasPrefix:@"http://upload-images.jianshu.io/upload_images/1"])
        //        {
        [array addObject:string];
        //        }
    }
    _imageArray=array;
    
    
}

- (BOOL)clickimageWithWebView:(UIWebView *)webView WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;{
    
    
    if(_showImage){
         if (_imageArray.count==0)
        {
            //需要明确的是图片也是链接，点击的时候也会执行这个方法，但是有时候图片太多，循环对比太麻烦，
            //通过添加手势获取位置，根据JS获取图片链接,有时候点击图片没有反应
            _imageArray= [  webView getImgs];//获取所有图片链接
            NSMutableArray *array=[[ NSMutableArray alloc] init];
            for (NSString *string in _imageArray) //剔除没有规则的图集
            {
                //                     if ([string hasPrefix:@"http://upload-images.jianshu.io/upload_images/1"])
                //                     {
                [array addObject:string];
                //                     }
            }
            _imageArray=array;
            
        }else
        {   //需要根据规律截取,本案例好像把简书的logo都。。。。。
            NSString *requesturl=[[ NSString stringWithFormat:@"%@",request.URL] substringFromIndex:4];
            NSLog(@"%@",requesturl);
            for (NSInteger indes=0; indes<_imageArray.count; indes++)
            {
                NSString *url=[NSString stringWithFormat:@"%@",_imageArray[indes]];
                if ([url isEqualToString:requesturl])
                {
                    [self pushPicController:requesturl withPoint:indes];//显示图集
                    break;
                }
                
            }
        return YES;
            
        }

    }
    
        
    return YES;
    
}

/**
 * 图片浏览器
 */
-(void)pushPicController:(NSString *)url withPoint:(NSInteger)CurrentIndex{
    
    YWWebScrollView *scrollView=[[YWWebScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrollView. ScrollViewTag=CurrentIndex;
    scrollView.imageUrls =_imageArray;
    scrollView.alpha=0.2;
    [UIView animateWithDuration:0.2f animations:^{
        scrollView.alpha = 1.0f;
    }];
}

// 点击内部链接使用safar加载（跳出app）
-(BOOL)webViewWithSafariOpenUrlWithWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL =[request URL  ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL:  requestURL ];
    }
    return YES;
}





//
//// 点击内部链接使用safar加载（跳出app）
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
//{
//    NSURL *requestURL =[request URL  ];
//    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
//        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
//        return ![ [ UIApplication sharedApplication ] openURL:  requestURL ];
//    }
//    return YES;
//}









/**
 *  使网页中的图片适应屏幕的宽度
 *
 *  @param webView webView
 */
- (void)autoImageSizeToScreenSizeWithWebView:(UIWebView *)webView{
    
    NSString *  js = @"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth=%f;" //缩放系数
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = maxwidth;"
    "myimg.height = myimg.height * (maxwidth/oldwidth);"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    [webView stringByEvaluatingJavaScriptFromString:js];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}




- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if(!self.isLoading) {
        self.uiWebViewIsLoading = NO;
        
        [self fakeProgressBarStopLoading];
    }
    
}





#pragma mark - WKNavigationDelegate


#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

#pragma mark - External App Support

- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {
    
    //若需要限制只允许某些前缀的scheme通过请求，则取消下述注释，并在数组内添加自己需要放行的前缀
    //    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https",@"file"]];
    //    return ![validSchemes containsObject:URL.scheme];
    
    return !URL;
}

- (void)launchExternalAppWithURL:(NSURL *)URL {
    self.URLToLaunchWithPermission = URL;
    if (![self.externalAppPermissionAlertView isVisible]) {
        [self.externalAppPermissionAlertView show];
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView == self.externalAppPermissionAlertView) {
        if(buttonIndex != alertView.cancelButtonIndex) {
            [[UIApplication sharedApplication] openURL:self.URLToLaunchWithPermission];
        }
        self.URLToLaunchWithPermission = nil;
    }
}


#pragma mark - Dealloc

- (void)dealloc {
    [self setDelegate:nil];
    [self.progressView  removeFromSuperview];
    self.progressView = nil;
}

@end
