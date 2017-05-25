#import <UIKit/UIKit.h>
//   http://139.129.213.138/api/index.php?act=login&op=register
/** 统一的一个请求路径 */
//NSString  * const HttpCommonURL = @"http://139.129.213.138/";

//NSString  * const HttpCommonURL = @"http://fanshi.ccifc.cn/";


/** 网络环境(在 tool.h里面修改)
 
 1 代表正式环境
 
 2 代表内网环境
*/

#if   kNetWorkEnvironment==1
NSString  * const HttpCommonURL = @"http://www.7xiaofu.com/";
#elif kNetWorkEnvironment==2
NSString  * const HttpCommonURL = @"http://10.216.2.11/";
#else

#endif

/** 手机号注册 */
NSString  * const HttpRegister = @"/api/index.php?act=login&op=register";
/** 协议 */
//NSString  * const HttpXieyi = @"api/index.php?act=login&op=register_body";
NSString  * const HttpXieyi = @"download/xieyi/xieyi.html";

/** 手机号登陆
 post:api.php/user/login/tel/18801097648/pass/123123
 */
NSString  * const HttpPhoneLogin = @"/api/index.php?act=login&op=index";


/** 获取验证码
 post:/api.php/verify/sendCode/   api.php/verify/sendCode
tel#手机号码
type#(1注册,2忘记密码，3绑定手机号)
*/
NSString  * const HttpVerify = @"/api/index.php?act=send&op=code";


/** 忘记密码保存密码
 post:api.php/user/resetPass/tel/18801097648/pass/123123/code/455363
 tel#手机号（登录名）
 pass#新密码
 code#验证码
 */
NSString  * const HttpResetPass = @"api/index.php?act=shop&op=forget_member_password";


/** 修改密码
 post:/api.php/User/editPassword
 uid#登陆者id
 oldpass#原密码
 newpass#新密码
 card_number#身份证号
 */
NSString  * const HttpEditPassword = @"api.php/user/resetPass/";
 
/*修改密码*/
NSString  * const HttpOp_Edit_password = @"api/index.php?act=member_index&op=edit_password";

