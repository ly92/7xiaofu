#import <UIKit/UIKit.h>


/** 商品分类 */
NSString  * const HttpShopClass = @"api/index.php?act=goods_class";

/** 商品列表 */
NSString  * const HttpShopList = @"api/index.php?act=goods&op=goods_list";

/** 商品详情 */
NSString  * const HttpShopDetaile = @"api/index.php?act=goods&op=goods_detail";

/** 地区列表 */
NSString  * const HttpAdressAreaList = @"api/index.php?act=member_address&op=area_list";

/** 新增收货地址 */
NSString  * const HttpAddAdress = @"api/index.php?act=member_address&op=address_add";

/** 编辑收货地址 */
NSString  * const HttpEditAdress = @"api/index.php?act=member_address&op=address_edit";

/** 删除收货地址 */
NSString  * const HttpDelAdress =@"api/index.php?act=member_address&op=address_del";

/** 收货地址列表 */
NSString  * const HttpAdressList =@"api/index.php?act=member_address&op=address_list";

/** 设为默认收货地址 */
NSString  * const HttpSetDefaultAdress = @"api/index.php?act=member_address&op=address_set_default";

/** 收藏列表 */
 NSString  * const HttpShopCollectList = @"api/index.php?act=member_favorites&op=favorites_list";

/** 添加收藏 */
 NSString  * const HttpShopAddCollect =@"api/index.php?act=member_favorites&op=favorites_add";

/** 删除收藏 */
 NSString  * const HttpShopDelCollect =@"api/index.php?act=member_favorites&op=favorites_del";

/** 购物车--添加 */
NSString  * const HttpShopAddCar = @"api/index.php?act=member_cart&op=cart_add";

/** 购物车--删除 */
NSString  * const HttpShopDelCar =@"api/index.php?act=member_cart&op=cart_del";

/** 购物车--编辑 */
NSString  * const HttpShopEditCar =@"api/index.php?act=member_cart&op=cart_edit_quantity";

/** 购物车--列表 */
NSString  * const HttpShopCarList =@"api/index.php?act=member_cart&op=cart_list";

/** 购物车--结算 */
NSString  * const HttpShopCarClearing =@"api/index.php?act=member_buy&op=buy_step1";
                //      params[@"ifcart"] = @"1";//  结算方式 【1，购物车】 【0，立即购买】

/** 变更地址时从新获取加密数据 */
NSString  * const HttpShopCarEditAdressLoadHash = @"api/index.php?act=member_buy&op=changes_address";

/** 购物车结算 */
NSString  * const HttpShopCarJieSuan =@"api/index.php?act=member_buy&op=buy_step2";

/** 商城订单 */
NSString  * const HttpShopOrderList =@"api/index.php?act=member_order&op=order_list";

/** 取消订单 */
NSString  * const HttpShopOrderCancel =@"api/index.php?act=member_order&op=order_cancel";

/** 删除订单 */
NSString  * const HttpShopOrderDel =@"api/index.php?act=member_order&op=order_delete";

/** 发货前删除订单 */
NSString  * const HttpShopOrderCancleBeforDeliver = @"api/index.php?act=member_order&op=add_return_all";

/** 确认收货 */
 NSString  * const HttpShopOrderFinish =@"api/index.php?act=member_order&op=order_receive";

/** 订单详情 */
NSString  * const HttpShopOrderDeatile =@"api/index.php?act=member_order&op=show_order";

/** 工程师库存分布 */
NSString  * const HttpShopEngStorageList=@"api/index.php?act=goods&op=engStorageList";

/** 商品位置 */
NSString  * const HttpShopStorageDetail =@"api/index.php?act=goods&op=storageDetail";

/** 退款退货 */
NSString  * const HttpShopAdd_refund_all = @"api/index.php?act=member_order&op=add_refund_all";
/** 退款退货 */
NSString  * const HttpShopAdd_refund_all1 = @"api/index.php?act=member_order&op=refund_return_step_one";
/** 退款退货 */
NSString  * const HttpShopAdd_refund_all2 = @"api/index.php?act=member_order&op=add_refund_all";

/** 订单再次支付 */
NSString  * const HttpShopCheckstand_save = @"api/index.php?act=member_order&op=checkstand_save";

/** 提醒发货 */
NSString  * const HttpShopAddStoreMsg = @"tp.php/Home/My/addStoreMsg";


/** 查看物流信息 */
NSString  * const HttpShopLogisticsInfo = @"/shop/index.php?act=login&op=wuliuxiangqing&order_id=";


/** 所有工程师库存分布 */
NSString  * const HttpShopEngStorageList2=@"api/index.php?act=goods&op=engStorageList2";
















































































