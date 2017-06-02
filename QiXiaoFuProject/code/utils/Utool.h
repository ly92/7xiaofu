//
//  Tool.h
//  shop
//
//  Created by XuDong Jin on 14-5-25.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utool : NSObject


//延迟执行的block
+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
 

//设置button点击效果
+ (void)setBtnSelectedStyle:(UIButton*)sender Image:(NSString*)image;


//获取view的controller
+ (UIViewController *)viewController:(UIView*)view;
  

//针对某一个控件截屏
+ (UIImage *)snapshot:(UIView *)view;


//高度获取
+ (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

+ (NSString *)timeStamp2TimeFormatter:(NSString *)timeSttamp;
+ (NSString *)timeStampPointTimeFormatter:(NSString *)timeSttamp;
+ (NSString *)timeStamp3TimeFormatter:(NSString *)timeSttamp;
+ (NSString *)timeStamp4TimeFormatter:(NSString *)timeSttamp;

+ (NSString *)comment_timeStamp2TimeFormatter:(NSString *)timeSttamp;
+ (NSString *)systemMessage_timeStamp2TimeFormatter:(NSString *)timeSttamp;
+ (NSString *)messageIndex_timeStamp2TimeFormatter:(NSString *)timeSttamp;

/**
 时间转换成时间戳
 
 @param date 当前时间
 
 @return 转换为的时间戳
 */
+(NSString *)timestamp:(NSDate *)date;
/**
 字符串格式的时间转换成时间戳
 
 @param string 字符串格式的时间
 @param format 时间的格式
 
 @return 转换为的时间戳
 */
+ (NSString  *)timestampForDateFromString:(NSString *)string withFormat:(NSString *)format;

/**
 字符串格式的时间转换成时间
 
 @param string 字符串格式的时间
 @param format 时间的格式
 
 @return 转换为的时间
 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

//本地存储文件
+(BOOL)saveFileToLoc:(NSString *) fileName theFile:(id)file;
//读取本地文件
+(UIImage*) getFileFromLoc:(NSString*)filePath;

//保存图片
-(void)saveImageDocuments:(UIImage *)image withImageName:(NSString *)imagename;
// 读取并存贮到相册
-(UIImage *)getDocumentImageWithImageName:(NSString *)imageName;


/**
 *  验正用户有没有登录和是否实名认证
 *
 */
+ (void)verifyLoginAndCertification:(UIViewController *)vc LogonBlock:(void (^)(void))LogonBlock CertificationBlock:(void (^)(void))CertificationBlock;
/**
 *  验正用户有没有绑定手机号码
 *
 */
+ (void)verifyLogin:(UIViewController *)vc LogonBlock:(void (^)(void))LogonBlock;


@end
