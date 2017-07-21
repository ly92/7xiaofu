//
//  WebCell.m
//  WebViewCellDemo
//
//  Created by xiayong on 16/8/31.
//  Copyright © 2016年 bianguo. All rights reserved.
//

#import "WebCell2.h"
#import "YWWebScrollView.h"
#import "Html5Utils.h"


@interface WebCell2 ()<UIWebViewDelegate>{

    NSMutableArray *_imageArray; //用于保存图片链接

}

@end

@implementation WebCell2
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSLog(@"%@",NSStringFromCGRect(self.contentView.bounds));
        
        // 高度必须提前赋一个值 >0
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(8, 0, kScreenWidth - 16, 1)];
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.opaque = NO;
//        self.webView.userInteractionEnabled = NO;
        self.webView.scrollView.bounces = NO;
        self.webView.delegate = self;
        self.webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
        self.webView.scalesPageToFit = YES;
        [self.contentView addSubview:self.webView];
        
        
        _imageArray=[[ NSMutableArray alloc] init];

        
        
    }
    return self;
}

// contentStr 用于更新值
-(void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:36px;color:#6e6e6e;font-family: sans-serif;}\n"
                       "table{width: 100%%;}"
                       "table,"
                       "table tr th,"
                       "table tr td {"
                       "border: 1px solid #c1c1c1;"
                       "height:70px;}"
                       "table {"
                        "text-align: left;"
                       "font-size:35px;"
                       "border-collapse: collapse;}"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>",_contentStr];   // htmlImgStr
    
    
    [self.webView loadHTMLString:htmls baseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}

- (void)setHtmlUrl:(NSString *)htmlUrl{

    NSURL *url = [NSURL URLWithString:htmlUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 如果要获取web高度必须在网页加载完成之后获取
    
    // 方法一
//    CGSize fittingSize = [self.webView sizeThatFits:CGSizeZero];
    
    // 方法二
    CGSize fittingSize = webView.scrollView.contentSize;
    //NSLog(@"webView:%@",NSStringFromCGSize(fittingSize));
    
    self.height = fittingSize.height + 10;
    
    self.webView.frame = CGRectMake(8, 0, kScreenWidth - 16, fittingSize.height);
    
    
    if (_webCell2ReturnHeightBlock) {
        _webCell2ReturnHeightBlock(self,fittingSize.height + 10);
    }
    
    [self webViewShowImagePhotoBrowerWithWebView:webView];
    
  
}

//监视请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return  [self clickimageWithWebView:webView WithRequest:request navigationType:navigationType];
}




/**
 *  给图片添加点击方法
 *
 *  @param webview webview
 */

- (void)webViewShowImagePhotoBrowerWithWebView:(UIWebView *)webview{
    
//    NSString *js = @"function imgAutoFit() { \
//    var imgs = document.getElementsByTagName('img'); \
//    for (var i = 0; i < imgs.length; ++i) {\
//    var img = imgs[i];   \
//    img.style.maxWidth = %f;   \
//    } \
//    }";
//    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
//    [webview stringByEvaluatingJavaScriptFromString:js];
//    [webview stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
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
//            NSLog(@"%@",requesturl);
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













@end
