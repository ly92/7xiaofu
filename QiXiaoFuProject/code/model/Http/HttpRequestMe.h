#import <UIKit/UIKit.h>


/** 我的首页 */
UIKIT_EXTERN NSString  * const HttpMeInfo;

/** 实名认证提交 */
UIKIT_EXTERN NSString  * const HttpMeUpdateMyReal;

/** 实名认证显示 */
UIKIT_EXTERN NSString  * const HttpMeShowMyReal;


/** 上传图片 -- 统一上传图片接口 */
UIKIT_EXTERN NSString  * const HttpMeUploadImage;


/** 个人其他资料显示 */
UIKIT_EXTERN NSString  * const HttpMeShowMemberInfo;

/** 修改头像 */
UIKIT_EXTERN NSString  * const HttpMeChangeHeaderImage;

/** 个人其他资料修改 */
UIKIT_EXTERN NSString  * const HttpMeUpdateMemberInfo;


/** 加入我们 */
UIKIT_EXTERN NSString  * const HttpMeJoinWe ;

/**操作手册 */
UIKIT_EXTERN NSString  * const HttpMeHelp_body;

/**关于我们 */
UIKIT_EXTERN NSString  * const HttpMeAboutWe;


/*==========================功能==========================*/

/**我的发单列表*/
UIKIT_EXTERN NSString  * const HttpMeMyBillList;

/**我的发单详情*/
UIKIT_EXTERN NSString  * const HttpMeMyBillDetail;

/**我的接单列表*/
UIKIT_EXTERN NSString  * const HttpMeMyOtList;

/**我的接单详情*/
UIKIT_EXTERN NSString  * const HttpMeMyOtDetail;

/**工程师取消发单*/
UIKIT_EXTERN NSString  * const HttpMeMyEngOffBill;

/**工程师取消发单*/
UIKIT_EXTERN NSString  * const HttpMeShowReSetBill ;

/**工程师取消发单*/
UIKIT_EXTERN NSString  * const HttpMeShowReSetBill;

/**发单重新发布提交*/
UIKIT_EXTERN NSString  * const HttpMeReSetBill;

/**工程师完成接单*/
UIKIT_EXTERN NSString  * const HttpMeEngSuccBill;

/**工程师删除接单*/
UIKIT_EXTERN NSString  * const HttpMeEngDelBill;

/**撤销发单*/
UIKIT_EXTERN NSString  * const HttpMeUndoBill ;

/**客户调价●比原价低*/
UIKIT_EXTERN NSString  * const HttpMeUpBillPriceGuest ;

/**客户调价●比原价高*/
UIKIT_EXTERN NSString  * const HttpMeUpBillPriceGuestPay ;

/**调价工程师确认*/
UIKIT_EXTERN NSString  * const HttpMeUpBillPriceEng ;

/**客户取消发单*/
UIKIT_EXTERN NSString  * const HttpMeOffBill ;

/**客户完成发单*/
UIKIT_EXTERN NSString  * const HttpMeComBill ;

/**客户对已完成发单评价*/
UIKIT_EXTERN NSString  * const HttpMeAddEngEvaluation;

/**客户完成补单*/
UIKIT_EXTERN NSString  * const HttpMeEngComBill;

/**客户删除发单*/
UIKIT_EXTERN NSString  * const HttpMeMyBillDel;

/**客户-去支付*/
UIKIT_EXTERN NSString  * const HttpMeRePayBill;

/**客户未完成发单*/
UIKIT_EXTERN NSString  * const HttpMeNoBill;

// =============================支付密码
/**是否设置支付密码*/
UIKIT_EXTERN NSString  * const HttpMeCheckPayPwd;

/** 设置支付密码 */
UIKIT_EXTERN NSString  * const HttpMeSetPayPwd;

/** 修改付密码 */
UIKIT_EXTERN NSString  * const HttpMeUpPayPwd;

/*****************************************/
/** 修改资格证书 */
UIKIT_EXTERN NSString  * const HttpMeUpdateMemberInfoCer;

/** 关联账号 */
UIKIT_EXTERN NSString  * const HttpMeMyUniAcc;

/** 设置备注名 */
UIKIT_EXTERN NSString  * const HttpMeSetMemberNote;

/** 获取备件SN码 */
UIKIT_EXTERN NSString  * const HttpMeGetEngGoodsSn;

/** 小库存-销库存 */
UIKIT_EXTERN NSString  * const HttpMeClearEngGoodsSn;

/** 小库存-更换地址 */
UIKIT_EXTERN NSString  * const HttpMeSaveEngGoodsSnArea;

/** 小库存-筛选 */
UIKIT_EXTERN NSString  * const HttpMeSearchEngGoodsSn;

/** 工程师开始工作 */
UIKIT_EXTERN NSString  * const HttpMeEngStartWork;

/***********************************************/

/** 充值 */
UIKIT_EXTERN NSString  * const HttpMeRecharge;

/** 钱包明细 */
UIKIT_EXTERN NSString  * const HttpMeShowBalanceDetail;

/** 我的钱包 */
UIKIT_EXTERN NSString  * const HttpMeShowBalance;


/** 提现申请 */
UIKIT_EXTERN NSString  * const HttpMeReCash;


/** 检查验证码是否正确 ---  用于找回平台支付密码*/
UIKIT_EXTERN NSString  * const HttpMeCheckVerify;


/** 收益记录---  用于找回平台支付密码*/
UIKIT_EXTERN NSString  * const HttpMeShouyiJilu;

/** 删除证书*/
UIKIT_EXTERN NSString  * const HttpDelMemberInfoCer;


/***********************   订单转移   ************************/

/** 开始转移*/
UIKIT_EXTERN NSString  * const HttpTransferStartMove;
/** 拒绝转移*/
UIKIT_EXTERN NSString  * const HttpTransferRefuseMove;
/** 同意转移*/
UIKIT_EXTERN NSString  * const HttpTransferAgreeMove;

