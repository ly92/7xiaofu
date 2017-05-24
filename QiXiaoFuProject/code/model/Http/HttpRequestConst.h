#import <UIKit/UIKit.h>
#import "tool.h"

/** 统一的一个请求路径 */
UIKIT_EXTERN NSString  * const HttpCommonURL;


/** 手机号注册
 
 post:/api.php?s=/user/register/
 tel#手机号
 code#验证码
 invit_code#邀请码
 */
UIKIT_EXTERN NSString  * const HttpRegister;

// api/index.php?act=login&op=register_body

UIKIT_EXTERN NSString  * const HttpXieyi;


/** 手机号登陆
 post:api.php?s=/user/login/tel/18801097648/pass/123123
 tel#手机号
 pass#密码
 */
UIKIT_EXTERN NSString  * const HttpPhoneLogin;

/** 获取验证码
 post:/api.php?s=/verify/sendCode/
 tel#手机号码
 type#(1注册,2忘记密码，3绑定手机号)
 */
UIKIT_EXTERN NSString  * const HttpVerify;

/** 忘记密码保存密码
 post:api.php?s=/user/resetPass/tel/18801097648/pass/123123/code/455363
 tel#手机号（登录名）
 pass#新密码
 code#验证码
 */
UIKIT_EXTERN NSString  * const HttpResetPass;


/** 修改密码
 post:/api.php?s=/User/editPassword
 uid#登陆者id
 oldpass#原密码
 newpass#新密码
 card_number#身份证号
 */
UIKIT_EXTERN NSString  * const HttpEditPassword;
#define HttpEditPasswordParam(uid,oldpass,newpass,card_number) @{@"uid":uid,@"oldpass":@"oldpass",@"newpass":@"newpass",@"card_number":@"card_number"}



/*修改密码*/
UIKIT_EXTERN NSString  * const HttpOp_Edit_password;






























































