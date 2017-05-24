#import <UIKit/UIKit.h>


/** 未读消息数量 */
NSString  * const HttpMessageReadCount = @"api/index.php?act=member_index&op=my_message_count";



/** 消息列表 */
NSString  * const HttpMessageList = @"api/index.php?act=member_index&op=message_list";

/** 消息详情 */
NSString  * const HttpMessageDetaile =@"api/index.php?act=member_index&op=show_message";

/** 消息推送（极光推送） */
//    type	string	【1，APP内部】【2，H5】
//    key	string	【2，跳转APP商品信息】【3，跳转APP活动】【4，系统消息】【5，订单详情】
