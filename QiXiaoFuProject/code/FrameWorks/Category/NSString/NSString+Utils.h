//
//  NSString+Valid.h
//  TomtaoProject
//
//  Created by MiniC on 15/7/16.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

/**
 * 功能描述: MD5加密
 * 输入参数: N/A
 * 返 回 值: self
 */
- (NSString *)MD5;

/**
 * 功能描述: sha1加密
 * 输入参数: N/A
 * 返 回 值: self
 */
- (NSString *)sha1;

/**
 * 功能描述: 字符串反转
 * 输入参数: N/A
 * 返 回 值: self
 */
- (NSString *)reverse;

/**
 * 功能描述: 字符个数
 * 输入参数: N/A
 * 返 回 值: wordCount
 */
- (NSUInteger)wordCount;

/**
 * 功能描述: 去掉空格或换行
 * 输入参数: N/A
 * 返 回 值: self
 */
- (NSString *)trim;
/**
 * 功能描述: 截取字符串
 * 输入参数: from 起始索引 to 结束索引
 * 返 回 值: self
 */
- (NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;

/**
 * 功能描述: 替换字符串
 * 输入参数: origin 原字符 replacement 目标字符
 * 返 回 值: self
 */
- (NSString *)replaceAll:(NSString*)origin with:(NSString*)replacement;

/**
 * 功能描述: 分割字符串
 * 输入参数: separator 分隔符
 * 返 回 值: array
 */
- (NSArray *)split:(NSString*) separator;

/**
 * 功能描述: 分割字符串
 * 输入参数: separator 分隔符合集(eg: ,.!? ....)
 * 返 回 值: array
 */
- (NSArray *)charactersInSet:(NSString*) separator;

/**
 * 功能描述: 获取单个字符第一次出现的索引
 * 输入参数: str 字符
 * 返 回 值: index
 */
- (NSInteger)indexOfString:(NSString*)str;
/**
 * 功能描述: 获取单个字符最后一次出现的索引
 * 输入参数: str 字符
 * 返 回 值: index
 */
- (NSInteger)lastIndexOfString:(NSString*)str;

/**
 * 功能描述: 将字符串格式化成日期
 * 输入参数: string 格式
 * 返 回 值: NSDate
 */
- (NSDate*)formatToDateWithString:(NSString*)string;



/**
 * 功能描述: 将字符串格式化成日期
 * 输入参数: style 格式
 * 返 回 值: NSDate
 */
- (NSDate*)formatToDateWithStyle:(NSDateFormatterStyle)style;


#pragma mark - Boolean Helpers

/**
 * 功能描述: 是否为空字符串
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
+ (BOOL)isEmpty:(NSString*)string;

/**
 * 功能描述: 是否包含指定字符
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)contains:(NSString *)string;

/**
 * 功能描述: 是否以指定字符开始
 * 输入参数: suffix
 * 返 回 值: YES/NO
 */
- (BOOL)startsWith:(NSString*)prefix;
/**
 * 功能描述: 是否以指定字符结尾
 * 输入参数: suffix
 * 返 回 值: YES/NO
 */
- (BOOL)endsWith:(NSString*)suffix;

/**
 * 功能描述: 判断是否为中文
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
-(BOOL)isChinese;

-(BOOL)isNameValid;

/**
 * 功能描述: 判断是否为有效数字
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)isNumeric;
/**
 * 功能描述: 判断是否为电话
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)isTelephone;
/**
 * 功能描述: 判断是否为手机号码
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)isMobelphone;

#pragma mark ---
#pragma mark ---  按规则分割手机号码显示

- (NSString *)getNewPhoneStr1:(NSString *)phonestr;


#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard;;

/**
 * 功能描述: 判断是否为正确的密码格式
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)isPassword;


/**
 * 功能描述: 判断是否为有效邮箱格式
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)isValidEmail;


/*
 *  时间戳对应的NSDate
 */
@property (nonatomic,strong,readonly) NSDate * dateTimestamp;


/**
 *  字符串转data
 */
-(NSData *)strData;


/**
 *  处理json格式的字符串中的换行符、回车符
 */
-(NSString *)deleteSpecialCode;





/**
 *	随机生成UUID
 *	@return 生成的uuid字符串
 */
+(NSString*)getUUID_Ext;

/**
 *	生成随机数
 *	@param length 随机数的位数
 *	@return 随机数的字符串
 */
+(NSString *)getRandomNumberwithLength_Ext:(int)length;

/**
 *	生成随机字符串，区分大小写
 *	@param  字符长度
 *	@return 字符串
 */
+(NSString *)getRandomStringwithLength_Ext:(int)length;

/**
 *	生成随机字符和数字字符串
 *	@param length 字符串的长度
 *	@return 字符串
 */
+(NSString *)getRandomNumberAndStringWithLength_Ext:(int)length;



/**
 *	@brief	取得汉字的拼音首字母
 *
 *	@return	拼音首字母字符串(大写)
 */
- (NSString *)pinyinFirstLetter_Ext;

/**
 *	@brief	汉字转拼音字符串,带声调
 *
 *	@return	拼音字符串(小写)
 */
- (NSString *)pinyinString_Ext;

/**
 * @brief	汉字转拼音字符串没有声调
 *
 * @return 拼音字符串
 */
- (NSString *)pinyinNoTone_Ext;

/**
 * @brief	汉字转拼音字符串没有声调和空格
 *
 * @return 拼音字符串
 */
- (NSString *)pinyinNoToneAndSpace_Ext;



@end
