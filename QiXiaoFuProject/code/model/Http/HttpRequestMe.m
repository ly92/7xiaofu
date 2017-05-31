#import <UIKit/UIKit.h>


/** 我的首页 */
NSString  * const HttpMeInfo =@"api/index.php?act=member_index&op=index";

/** 实名认证提交 */
NSString  * const HttpMeUpdateMyReal = @"tp.php/Home/My/updateMyReal";

/** 实名认证显示 */
NSString  * const HttpMeShowMyReal =@"tp.php/Home/My/showMyReal";

/** 上传图片 -- 统一上传图片接口 */
NSString  * const HttpMeUploadImage = @"tp.php/Home/Public/Upload";

/** 个人其他资料显示 */
NSString  * const HttpMeShowMemberInfo = @"tp.php/Home/My/showMemberInfo";

/** 修改头像 */
NSString  * const HttpMeChangeHeaderImage =@"api/index.php?act=member_index&op=upheadimg";

/** 个人其他资料修改 */
NSString  * const HttpMeUpdateMemberInfo = @"tp.php/Home/My/updateMemberInfo";


/** 加入我们 */
NSString  * const HttpMeJoinWe =@"api/index.php?act=login&op=about_body";

/**操作手册 */
//NSString  * const HttpMeHelp_body =@"api/index.php?act=login&op=help_body";
NSString  * const HttpMeHelp_body =@"download/caozuoshouce/navi.html";

/**关于我们 */
//NSString  * const HttpMeAboutWe = @"api/index.php?act=login&op=guanyu";
NSString  * const HttpMeAboutWe = @"download/about/about.html";

/*==========================功能==========================*/

/**我的发单列表*/
NSString  * const HttpMeMyBillList = @"tp.php/Home/My/myBillList";

/**我的发单详情*/
NSString  * const HttpMeMyBillDetail = @"tp.php/Home/My/myBillDetail";

/**我的接单列表*/
NSString  * const HttpMeMyOtList = @"tp.php/Home/My/myOtList";

/**我的接单详情*/
NSString  * const HttpMeMyOtDetail = @"tp.php/Home/My/myOtDetail";

/**工程师取消接单*/
NSString  * const HttpMeMyEngOffBill = @"tp.php/Home/My/engOffBill";

/**发单重新发布显示*/
NSString  * const HttpMeShowReSetBill = @"tp.php/Home/My/showReSetBill";

/**发单重新发布提交*/
NSString  * const HttpMeReSetBill = @"tp.php/Home/My/reSetBill";

/**工程师完成接单*/
NSString  * const HttpMeEngSuccBill = @"tp.php/Home/My/engSuccBill";

/**工程师删除接单*/
NSString  * const HttpMeEngDelBill = @"tp.php/Home/My/engDelBill";

/**撤销发单*/
NSString  * const HttpMeUndoBill = @"tp.php/Home/My/undoBill";

/**客户调价●比原价低*/
NSString  * const HttpMeUpBillPriceGuest = @"tp.php/Home/My/upBillPriceGuest";

/**客户调价●比原价高*/
NSString  * const HttpMeUpBillPriceGuestPay = @"tp.php/Home/My/upBillPriceGuestPay";

/**调价工程师确认*/
NSString  * const HttpMeUpBillPriceEng = @"tp.php/Home/My/upBillPriceEng";

/**客户取消发单*/
NSString  * const HttpMeOffBill = @"tp.php/Home/My/offBill";

/**客户完成发单*/
NSString  * const HttpMeComBill = @"tp.php/Home/My/comBill";

/**客户对已完成发单评价*/
NSString  * const HttpMeAddEngEvaluation = @"tp.php/Home/My/addEngEvaluation";

/**客户完成补单*/
NSString  * const HttpMeEngComBill = @"tp.php/Home/My/engComBill";

/**客户删除发单*/
NSString  * const HttpMeMyBillDel = @"tp.php/Home/My/myBillDel";

/**客户-去支付*/
NSString  * const HttpMeRePayBill = @"tp.php/Home/My/rePayBill";

/**客户未完成发单*/
NSString  * const HttpMeNoBill = @"tp.php/Home/My/noBill";

// =============================支付密码
/**是否设置支付密码*/
NSString  * const HttpMeCheckPayPwd = @"tp.php/Home/My/checkPayPwd";

/** 设置支付密码 */
NSString  * const HttpMeSetPayPwd = @"tp.php/Home/My/setPayPwd";

/** 修改付密码 */
NSString  * const HttpMeUpPayPwd =@"tp.php/Home/My/upPayPwd";

/*****************************************/
/** 修改资格证书 */
NSString  * const HttpMeUpdateMemberInfoCer = @"tp.php/Home/My/updateMemberInfoCer";

/** 关联账号 */
NSString  * const HttpMeMyUniAcc = @"tp.php/Home/My/myUniAcc";

/** 设置备注名 */
NSString  * const HttpMeSetMemberNote = @"tp.php/Home/My/setMemberNote";

/** 获取备件SN码 */
NSString  * const HttpMeGetEngGoodsSn = @"tp.php/Home/My/getEngGoodsSn";


/** 小库存-销库存 */
NSString  * const HttpMeClearEngGoodsSn = @"tp.php/Home/My/clearEngGoodsSn";

/** 小库存-更换地址 */
NSString  * const HttpMeSaveEngGoodsSnArea = @"tp.php/Home/My/saveEngGoodsSnArea";

/** 小库存-筛选 */
NSString  * const HttpMeSearchEngGoodsSn = @"tp.php/Home/My/searchEngGoodsSn";


/** 工程师开始工作 */
NSString  * const HttpMeEngStartWork = @"tp.php/Home/My/engStartWork";

/***********************************************/

/** 充值 */
NSString  * const HttpMeRecharge = @"tp.php/Home/My/recharge";

/** 钱包明细 */
NSString  * const HttpMeShowBalanceDetail = @"tp.php/home/my/showBalanceDetail";

/** 我的钱包 */
NSString  * const HttpMeShowBalance = @"tp.php/home/my/showBalance";

/** 提现申请 */
NSString  * const HttpMeReCash = @"tp.php/Home/My/reCash";

/** 检查验证码是否正确 ---  用于找回平台支付密码*/
NSString  * const HttpMeCheckVerify = @"tp.php/Home/My/checkVerify";

/** 收益记录---  用于找回平台支付密码*/
NSString  * const HttpMeShouyiJilu = @"tp.php/Home/My/shouyijilu";

/** 删除证书*/
NSString  * const HttpDelMemberInfoCer = @"tp.php/Home/My/delMemberInfoCer";

/***********************   订单转移   ************************/

/** 开始转移*/
NSString  * const HttpTransferStartMove = @"tp.php/Home/My/startMove";
/** 拒绝转移*/
NSString  * const HttpTransferRefuseMove = @"tp.php/Home/My/refuseMove";
/** 同意转移*/
NSString  * const HttpTransferAgreeMove = @"tp.php/Home/My/billMove";

