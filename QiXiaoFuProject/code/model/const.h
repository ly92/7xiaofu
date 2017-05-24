//  const.h
//

//
//  系统名称：
//  功能描述：存放所有的宏以及一些特殊参数
//  修改记录：(仅记录功能修改)


#ifdef DEBUG
#define fString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define DeLog(...) printf("%s -->  %s---> 第%d行:\n\n %s\n\n", [fString UTF8String],__FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define DeLog(...)
#endif

//屏幕宽高
#define kScreenWidth   ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight   ([[UIScreen mainScreen] bounds].size.height)

//屏幕宽度比例系数
#define kScreenWidthScale  ([UIScreen mainScreen].bounds.size.width/375)
//屏幕高度系数比
#define kScreenHeightScale  ([UIScreen mainScreen].bounds.size.height/667)



// 颜色
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBA(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 随机色
#define RandomColor RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//特定颜色
#define kBackgroundColor kHexColor(F7F7F7)
#define kThemeColor kHexColor(DF5132)

//深灰色
#define YIWANG_DARK_GRAY_COLOR UIColorFromRGB(0x3b3b3b)
//浅灰色
#define YIWANG_LIGHT_GRAY_COLOR UIColorFromRGB(0xa1a1a1)


#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;


/*!
 *  用户 id
 */
//#define kUserId @"2835a150fa4d077224b34cbf7cb2fff9"
#define kUserId [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].userid)]
#define kPhone [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].phone)]
#define kStore_id [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].store_id)]
#define kStore_name [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].store_name)]
#define kPassword [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].password)]
#define kUserIcon [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].userIcon)]
#define kUserName [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].userName)]
#define kIs_real [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].is_real)]
//未读的系统消息数量
#define kUnreadSystemMessageNumber ([UserManager readModel].unreadSystemMessageNumber)



//#define kSex [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].sex)]
//#define kAge [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].age)]
//#define kZero_deposit [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].zero_deposit)]
//#define kDeposit [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].deposit)]
//#define kTelphone [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].telphone)]
//#define kAppKey [NSString stringWithFormat:@"%@",checkNULL([UserManager readModel].appkey)]


//  判断 字符串是否为 NULL 或者 nil
#define checkNULL(__X__) checkNull(__X__,@"")
#define checkNull(__X__,__Y__)  [(__X__) isKindOfClass:[NSNull class]] || (__X__) == nil|| (__X__) == NULL||[(__X__) isEqual:@"<null>"]||[(__X__) isEqual:@"(null)"]||[(__X__) isEqual:@"null"] ? [NSString stringWithFormat:@"%@", (__Y__)] : [NSString stringWithFormat:@"%@", (__X__)]

//在子线程中运行
#define GCDA(completion) dispatch_async(dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),completion)
//在主线程中运行
#define GCDM(completion) dispatch_async(dispatch_get_main_queue(),completion)


#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#define  kDefaultImage_Z        [UIImage imageNamed:@"default_Z"]
#define  kDefaultImage_header   [UIImage imageNamed:@"default_header"]
#define  kDefaultImage_c2   [UIImage imageNamed:@"default_c2"]
#define  kDefaultImage_c1   [UIImage imageNamed:@"default_c1"]

