//
//  NSString+Valid.m
//  TomtaoProject
//
//  Created by MiniC on 15/7/16.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "NSString+Utils.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Utils)




#define NotFound -1
/**
 * 功能描述: MD5加密
 * 输入参数: N/A
 * 返 回 值: self
 */
- (NSString *)MD5
{
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

/**
 * 功能描述: sha1加密
 * 输入参数: N/A
 * 返 回 值: self
 */
- (NSString *)sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data 	 = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

/**
 * 功能描述: 字符串反转
 * 输入参数: N/A
 * 返 回 值: self
 */
- (NSString *)reverse
{
    NSInteger length = [self length];
    unichar *buffer = calloc(length, sizeof(unichar));
    
    // TODO(gabe): Apparently getCharacters: is really slow
    [self getCharacters:buffer range:NSMakeRange(0, length)];
    
    for(int i = 0, mid = ceil(length/2.0); i < mid; i++)
    {
        unichar c = buffer[i];
        buffer[i] = buffer[length-i-1];
        buffer[length-i-1] = c;
    }
    
    NSString *reverseStr = [[NSString alloc] initWithCharacters:buffer length:length];
    free(buffer);
    buffer = nil;
    return reverseStr;
}

/**
 * 功能描述: 字符个数
 * 输入参数: N/A
 * 返 回 值: wordCount
 */
- (NSUInteger)wordCount
{
    
    __block NSUInteger wordCount = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *character, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              wordCount++;
                          }];
    return wordCount;
}

/**
 * 功能描述: 去掉空格或换行
 * 输入参数: N/A
 * 返 回 值: self
 */
- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 * 功能描述: 截取字符串
 * 输入参数: from 起始索引 to 结束索引
 * 返 回 值: self
 */
- (NSString *)substringFrom:(NSInteger)from to:(NSInteger)to
{
    NSString *rightPart = [self substringFromIndex:from];
    return [rightPart substringToIndex:to-from];
}

/**
 * 功能描述: 替换字符串
 * 输入参数: origin 原字符 replacement 目标字符
 * 返 回 值: self
 */
- (NSString *)replaceAll:(NSString*)origin with:(NSString*)replacement
{
    return [self stringByReplacingOccurrencesOfString:origin withString:replacement];
}

/**
 * 功能描述: 分割字符串
 * 输入参数: separator 分隔符
 * 返 回 值: array
 */
- (NSArray *)split:(NSString*) separator
{
    return [self componentsSeparatedByString:separator];
}


/**
 * 功能描述: 分割字符串
 * 输入参数: separator 分隔符合集
 * 返 回 值: array
 */
- (NSArray *)charactersInSet:(NSString*) separator{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:separator]];
}


/**
 * 功能描述: 获取单个字符第一次出现的索引
 * 输入参数: str 字符
 * 返 回 值: index
 */
- (NSInteger)indexOfString:(NSString*)str
{
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound)
    {
        return NotFound;
    }
    return range.location;
}

/**
 * 功能描述: 获取单个字符最后一次出现的索引
 * 输入参数: str 字符
 * 返 回 值: index
 */
- (NSInteger)lastIndexOfString:(NSString*)str
{
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch];
    if (range.location == NSNotFound)
    {
        return NotFound;
    }
    return range.location;
}

/**
 * 功能描述: 将字符串格式化成日期
 * 输入参数: string 格式
 * 返 回 值: NSDate
 */
- (NSDate*)formatToDateWithString:(NSString*)string
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:string];
    return [fmt dateFromString:self];
}

/**
 * 功能描述: 将字符串格式化成日期
 * 输入参数: style 格式
 * 返 回 值: NSDate
 */
- (NSDate*)formatToDateWithStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:style];
    return [fmt dateFromString:self];
}

#pragma mark - Boolean Helpers

/**
 * 功能描述: 是否为空字符串
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
+ (BOOL)isEmpty:(NSString*)string
{
    if (string == nil)
    {
        return YES;
    }
    else if (string == NULL)
    {
        return YES;
    }
    else if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if ([[string trim] isEqualToString:@""])
    {
        return YES;
    }
    else if ([string isEqualToString:@"<null>"]
             || [string isEqualToString:@"null"]
             || [string isEqualToString:@"(null)"]
             ||[string isEqualToString:@"NULL"]
             || [string isEqualToString:@"<NULL>"]
             || [string isEqualToString:@"(NULL)"])
    {
        return YES;
    }
    return NO;
}

/**
 * 功能描述: 是否包含指定字符
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)contains:(NSString *)string
{
    NSRange range = [self rangeOfString:string];
    return (range.location != NSNotFound);
}

/**
 * 功能描述: 是否以指定字符开始
 * 输入参数: suffix
 * 返 回 值: YES/NO
 */
- (BOOL)startsWith:(NSString*)prefix
{
    return [self hasPrefix:prefix];
}

/**
 * 功能描述: 是否以指定字符结尾
 * 输入参数: suffix
 * 返 回 值: YES/NO
 */
- (BOOL)endsWith:(NSString*)suffix
{
    return [self hasSuffix:suffix];
}

/**
 * 功能描述: 判断是否为中文
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}



-(BOOL)isNameValid
{
    BOOL isValid = NO;
    
    if (self.length > 0)
    {
        for (NSInteger i=0; i<self.length; i++)
        {
            unichar chr = [self characterAtIndex:i];
            
            if (chr < 0x80)
            { //字符
                if (chr >= 'a' && chr <= 'z')
                {
                    isValid = YES;
                }
                else if (chr >= 'A' && chr <= 'Z')
                {
                    isValid = YES;
                }
                else if (chr >= '0' && chr <= '9')
                {
                    isValid = NO;
                }
                else if (chr == '-' || chr == '_')
                {
                    isValid = YES;
                }
                else
                {
                    isValid = NO;
                }
            }
            else if (chr >= 0x4e00 && chr < 0x9fa5)
            { //中文
                isValid = YES;
            }
            else
            { //无效字符
                isValid = NO;
            }
            
            if (!isValid)
            {
                break;
            }
        }
    }
    
    return isValid;
}



/**
 * 功能描述: 判断是否为有效数字
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)isNumeric
{
    NSCharacterSet *unwantedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    return ([self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

/**
 * 功能描述: 判断是否为电话
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)isTelephone
{
    NSCharacterSet *unwantedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-"] invertedSet];
    return ([self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

/**
 * 功能描述: 判断是否为手机号码
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)isMobelphone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    return  [regextestmobile evaluateWithObject:self]   ||
    [regextestct evaluateWithObject:self]       ||
    [regextestcu evaluateWithObject:self]       ||
    [regextestcm evaluateWithObject:self];
}

#pragma 正则匹配用户身份证号15或18位
- (BOOL)checkUserIdCard;
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}


#pragma mark ---
#pragma mark ---  按规则分割手机号码显示

- (NSString *)getNewPhoneStr1:(NSString *)phonestr
{
    if ([phonestr rangeOfString:@" "].length == 0 && phonestr.length > 6) {
        NSMutableString *phoneNumber = [NSMutableString string];
        NSString *subStr = [phonestr substringToIndex:3];
        [phoneNumber appendFormat:@"%@ ",subStr];
        subStr = [phonestr substringWithRange:NSMakeRange(3, 4)];
        [phoneNumber appendFormat:@"%@ ",subStr];
        subStr = [phonestr substringWithRange:NSMakeRange(7, phonestr.length-7)];
        [phoneNumber appendString:subStr];
        
        phonestr = phoneNumber;
    }
    
    return phonestr;
}

/**
 * 功能描述: 判断是否为正确的密码格式
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)isPassword
{
    NSString *		regex = @"(^[A-Za-z0-9]{6,16}$)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}



/**
 * 功能描述: 判断是否为有效邮箱格式
 * 输入参数: N/A
 * 返 回 值: YES/NO
 */
- (BOOL)isValidEmail
{
    BOOL isValidEmail = YES;
    NSString *pattern = [NSString stringWithFormat:@"[A-Z0-9]+@[A-Z0-9_-]+\\.[A-Z]{2,4}"];
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSRange range;
    range.location = 0;
    range.length = [self length];
    
    if ([regEx numberOfMatchesInString:self options:0 range:range] == 0) {
        
        isValidEmail = NO;
    }
    return isValidEmail;
}


/*
 *  时间戳对应的NSDate
 */
-(NSDate *)dateTimestamp{
    
    NSTimeInterval timeInterval=self.floatValue;
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}


-(NSData *)strData{
    
    NSRange range = [self rangeOfString:@"file://"];
    
    if(range.length!=0){
        
        NSLog(@"请注意：您可能是想要获取本地文件(%@)数据,而不是将此URL地址直接转为对应的NSData。",self);
    }
    
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}


/**
 *  处理json格式的字符串中的换行符、回车符
 */
-(NSString *)deleteSpecialCode {
    
    NSString *string = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return string;
}



+(NSString*)getUUID_Ext
{
    CFUUIDRef puuid = CFUUIDCreate( kCFAllocatorDefault );
    CFStringRef uuidString = CFUUIDCreateString( kCFAllocatorDefault, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( kCFAllocatorDefault, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+(NSString *)getRandomNumberwithLength_Ext:(int)length
{
    if (length==0 ||length<0)
    {
        return nil;
    }
    NSMutableString * result=[NSMutableString string];
    
    for (int i=0; i<length; i++)
    {
        if (i==0)
        {
            [result appendFormat:@"%d",arc4random()%9+1];
        }
        else{
            [result appendFormat:@"%d",arc4random()%10];
        }
    }
    
    return result;
}

+(NSString *)getRandomStringwithLength_Ext:(int)length
{
    
    if (length==0 ||length<0)
    {
        return nil;
    }
    NSMutableString * result=[NSMutableString string];
    
    for (int i=0; i<length; i++)
    {
        if ((arc4random()%2+1)%2==0)
        {
            [result appendFormat:@"%c",arc4random()%26+97];
        }
        else{
            [result appendFormat:@"%c",arc4random()%26+65];
        }
    }
    
    return result;
}

+(NSString *)getRandomNumberAndStringWithLength_Ext:(int)length
{
    if (length==0 ||length<0)
    {
        return nil;
    }
    NSMutableString * result=[NSMutableString string];
    
    for (int i=0; i<length; i++)
    {
        if ((arc4random()%3+1)==1)
        {
            [result appendFormat:@"%c",arc4random()%26+97];
        }
        else if ((arc4random()%3+1)==1)
        {
            [result appendFormat:@"%c",arc4random()%26+65];
        }
        else{
            [result appendFormat:@"%d",arc4random()%10];
        }
    }
    
    return result;
}



/**
 *	@brief	汉字转拼音字符串
 *
 *	@return	拼音字符串(小写)
 */
- (NSString *)pinyinString_Ext
{
    if (self==nil) {
        return nil;
    }
    
    CFMutableStringRef string =CFStringCreateMutableCopy(NULL, 0, (CFStringRef)self);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    // CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    CFAutorelease(string);
    
    return (__bridge NSString *)string;
}


- (NSString *)pinyinNoTone_Ext
{
    if (self==nil) {
        return nil;
    }
    
    CFMutableStringRef string =CFStringCreateMutableCopy(NULL, 0, (CFStringRef)self);
    ///转换成拼音
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    ///去掉声调
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    CFAutorelease(string);    //
    
    return (__bridge NSString *)string;
}

- (NSString *)pinyinNoToneAndSpace_Ext
{
    if (self==nil) {
        return nil;
    }
    NSString * string=[self pinyinNoTone_Ext];
    string=[string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}


/**
 *	@brief	取得汉字的拼音首字母
 *
 *	@return	拼音首字母字符串(大写)
 */
- (NSString *)pinyinFirstLetter_Ext
{
    if (self==nil) {
        return nil;
    }
    NSMutableString * string=[NSMutableString string];
    
    @try {
        NSString *noToneString=[self pinyinNoTone_Ext];
        NSArray *spaceList=[noToneString componentsSeparatedByString:@" "];
        for (int i=0; i<[spaceList count]; i++) {
            [string appendFormat:@"%c",[spaceList[i] UTF8String][0]];
        }
        
        /*
         for (int i=0; i<[self length]; i++) {
         [string appendFormat:@"%c",ESPinyinFirstLetter_Ext([string characterAtIndex:i])];
         }*/
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    return [string uppercaseString];
}




@end
