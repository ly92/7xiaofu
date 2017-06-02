//
//  Tool.m
//  shop
//
//  Created by XuDong Jin on 14-5-25.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Utool.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "BlockUIAlertView.h"
#import "CertificationViewController.h"

@implementation Utool

//延迟执行的block
+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

+ (void)fireBlockAfterDelay:(void (^)(void))block
{
    block();
}

 
//设置button点击效果
+ (void)setBtnSelectedStyle:(UIButton*)sender Image:(NSString*)image{
    if (image) {
        [sender setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateSelected];
    }
    [sender setSelected:YES];
    
    [Utool performBlock:^{
        [sender setSelected:NO];
    } afterDelay:0.05];

}



//获取view的controller
+ (UIViewController *)viewController:(UIView*)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


//针对某一个控件截屏
+ (UIImage *)snapshot:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//高度获取
+ (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

// 时间格式化
+ (NSString *)timeStamp4TimeFormatter:(NSString *)timeSttamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSttamp doubleValue]];
    NSString  * date = [formatter stringFromDate:confromTimesp];
    return date;
}
+ (NSString *)timeStamp2TimeFormatter:(NSString *)timeSttamp{

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSttamp doubleValue]];
    NSString  * date = [formatter stringFromDate:confromTimesp];
    return date;
}
+ (NSString *)timeStampPointTimeFormatter:(NSString *)timeSttamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSttamp doubleValue]];
    NSString  * date = [formatter stringFromDate:confromTimesp];
    return date;
}

+ (NSString *)timeStamp3TimeFormatter:(NSString *)timeSttamp{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日HH时"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSttamp doubleValue]];
    NSString  * date = [formatter stringFromDate:confromTimesp];
    return date;
}


+ (NSString *)comment_timeStamp2TimeFormatter:(NSString *)timeSttamp{
    if (timeSttamp.length > 10){
        timeSttamp = [timeSttamp substringToIndex:10];
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSttamp doubleValue]];
    NSString  * date = [formatter stringFromDate:confromTimesp];
    return date;
}

+ (NSString *)systemMessage_timeStamp2TimeFormatter:(NSString *)timeSttamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日  HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSttamp doubleValue]];
    NSString  * date = [formatter stringFromDate:confromTimesp];
    return date;
}
+ (NSString *)messageIndex_timeStamp2TimeFormatter:(NSString *)timeSttamp{

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSttamp doubleValue]];
    NSString  * date = [formatter stringFromDate:confromTimesp];
    return date;


}






/**
 时间转换成时间戳

 @param date 当前时间

 @return 转换为的时间戳
 */
+(NSString *)timestamp:(NSDate *)date{
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval];
    return [timeString copy];
}

/**
 字符串格式的时间转换成时间戳

 @param string 字符串格式的时间
 @param format 时间的格式

 @return 转换为的时间戳
 */
+ (NSString  *)timestampForDateFromString:(NSString *)string withFormat:(NSString *)format{

   NSDate * date =  [self dateFromString:string withFormat:format];
    return [self timestamp:date];
}

/**
 字符串格式的时间转换成时间

 @param string 字符串格式的时间
 @param format 时间的格式

 @return 转换为的时间
 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}



//本地存储文件
+(BOOL)saveFileToLoc:(NSString *) fileName theFile:(id) file{
    NSString *str = [NSString stringWithFormat:@"Documents/%@",fileName];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:str];
    //NSLog(@"%@",fileName);
    file = UIImageJPEGRepresentation(file, 1);
    NSFileManager* fm=[NSFileManager defaultManager];
    NSError * error;
      [fm removeItemAtPath:jpgPath error:&error];
    if(![fm fileExistsAtPath:jpgPath]){
        //下面是对该文件进行制定路径的保存
        BOOL b = [file writeToFile:jpgPath atomically:YES];
        return b;
    }
    return NO;
}

//读取本地文件
+(UIImage*) getFileFromLoc:(NSString*)filePath{
    NSString *str = [NSString stringWithFormat:@"Documents/%@",filePath];
    NSString  *filename = [NSHomeDirectory() stringByAppendingPathComponent:str];
    NSFileManager* fm=[NSFileManager defaultManager];
    if([fm fileExistsAtPath:filename]){
        //读取某个文件
        NSData *data = [fm contentsAtPath:filename];
        UIImage *img  = [UIImage imageWithData:data];
        return img;
    }
    return nil;
}

#pragma mark --验证是否登录 是否实名认证
+ (void)verifyLoginAndCertification:(UIViewController *)vc LogonBlock:(void (^)(void))LogonBlock CertificationBlock:(void (^)(void))CertificationBlock{
    
    UserInfoModel * userModel = [UserManager readModel];
    
    NSInteger  is_real = userModel.is_real;

    
    if(kUserId.length == 0){
        
        LoginViewController * lvc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        BaseNavigationController * nvc = [[BaseNavigationController alloc]initWithRootViewController:lvc];
        [vc presentViewController:nvc animated:YES completion:^{
        }];
        
    }else if (is_real != 1)  {
        
            BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"您尚未进行实名认证,认证之后才能接单,要立即去认证吗?" cancelButtonTitle:@"先等等" clickButton:^(NSInteger buttonIndex) {
                
                if(buttonIndex == 1){
                    
                    CertificationBlock();

                }
                
            } otherButtonTitles:@"去认证"];
            [alert show];
            
            
    }else{
    
        LogonBlock();
    }
   
}

+ (void)verifyLogin:(UIViewController *)vc LogonBlock:(void (^)(void))LogonBlock{
    
    if (kUserId.length == 0) {
        
        LoginViewController * lvc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        BaseNavigationController * nvc = [[BaseNavigationController alloc]initWithRootViewController:lvc];
        [vc presentViewController:nvc animated:YES completion:^{
           
        }];
        
        
    }else{
        
        LogonBlock();
        
     }
 }

//保存图片
-(void)saveImageDocuments:(UIImage *)image withImageName:(NSString *)imagename{
    //拿到图片
    UIImage *imagesave = image;
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString * imagePath = [NSString stringWithFormat:@"%@/%@.png",path_sandox,imagename];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(imagesave) writeToFile:imagePath atomically:YES];
}
// 读取并存贮到相册
-(UIImage *)getDocumentImageWithImageName:(NSString *)imageName{
    // 读取沙盒路径图片
    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),imageName];
    // 拿到沙盒路径图片
    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    return imgFromUrl3;
}


@end
