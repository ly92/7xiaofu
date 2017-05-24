//
//  GoodsDetaileModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Store_Info,Store_Credit,Store_Deliverycredit,Store_Desccredit,Store_Servicecredit,Goods_Info,Goods_Attr,Store_Server;
@interface GoodsDetaileModel : NSObject

@property (nonatomic, copy) NSString *share_content;

@property (nonatomic, strong) NSArray *mansong_server_list;

@property (nonatomic, strong) NSArray<NSString *> *goods_image;

@property (nonatomic, strong) NSArray <Store_Server *>*store_server;

@property (nonatomic, copy) NSString *share_title;

@property (nonatomic, strong) Goods_Info *goods_info;

@property (nonatomic, strong) NSArray *gift_array;

@property (nonatomic, strong) Store_Info *store_info;

@property (nonatomic, copy) NSString *mansong_info;

@property (nonatomic, copy) NSString *share_img_url;

@property (nonatomic, copy) NSString *share_link_url;

@property (nonatomic, assign) NSInteger IsHaveBuy;

@property (nonatomic, assign) NSInteger is_fav;

@end

@interface Store_Info : NSObject

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *store_ww;

@property (nonatomic, copy) NSString *member_name;

@property (nonatomic, copy) NSString *store_qq;

@property (nonatomic, assign) NSInteger good_percent;

@property (nonatomic, strong) Store_Credit *store_credit;

@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, copy) NSString *store_name;

@property (nonatomic, copy) NSString *store_id;

@property (nonatomic, assign) NSInteger all;

@property (nonatomic, copy) NSString *store_phone;

@end

@interface Store_Credit : NSObject

@property (nonatomic, strong) Store_Deliverycredit *store_deliverycredit;

@property (nonatomic, strong) Store_Desccredit *store_desccredit;

@property (nonatomic, strong) Store_Servicecredit *store_servicecredit;

@end

@interface Store_Deliverycredit : NSObject

@property (nonatomic, assign) NSInteger credit;

@property (nonatomic, copy) NSString *percent_class;

@property (nonatomic, copy) NSString *percent_text;

@property (nonatomic, copy) NSString *percent;

@property (nonatomic, copy) NSString *text;

@end

@interface Store_Desccredit : NSObject

@property (nonatomic, assign) NSInteger credit;

@property (nonatomic, copy) NSString *percent_class;

@property (nonatomic, copy) NSString *percent_text;

@property (nonatomic, copy) NSString *percent;

@property (nonatomic, copy) NSString *text;

@end

@interface Store_Servicecredit : NSObject

@property (nonatomic, assign) NSInteger credit;

@property (nonatomic, copy) NSString *percent_class;

@property (nonatomic, copy) NSString *percent_text;

@property (nonatomic, copy) NSString *percent;

@property (nonatomic, copy) NSString *text;

@end

@interface Goods_Info : NSObject

@property (nonatomic, copy) NSString *goods_costprice;

@property (nonatomic, copy) NSString *xianshi_info;

@property (nonatomic, copy) NSString *plateid_bottom;

@property (nonatomic, copy) NSString *gc_id_1;

@property (nonatomic, copy) NSString *gc_id_2;

@property (nonatomic, copy) NSString *gc_id_3;

@property (nonatomic, copy) NSString *have_gift;

@property (nonatomic, copy) NSString *color_id;

@property (nonatomic, copy) NSString *goods_serial;

@property (nonatomic, copy) NSString *virtual_indate;

@property (nonatomic, copy) NSString *goods_freight;

@property (nonatomic, copy) NSString *goods_discount;

@property (nonatomic, copy) NSString *goods_storage;

@property (nonatomic, copy) NSString *presell_deliverdate;

@property (nonatomic, copy) NSString *goods_storage_alarm;

@property (nonatomic, copy) NSString *goods_collect;

@property (nonatomic, copy) NSString *goods_img_laber;

@property (nonatomic, copy) NSString *goods_price;

@property (nonatomic, copy) NSString *areaid_1;

@property (nonatomic, copy) NSString *areaid_2;

@property (nonatomic, copy) NSString *is_appoint;

@property (nonatomic, copy) NSString *goods_salenum;

@property (nonatomic, copy) NSString *goods_stcids;

@property (nonatomic, strong) NSArray<Goods_Attr *> *goods_attr;

@property (nonatomic, copy) NSString *from_commonid;

@property (nonatomic, assign) NSInteger goods_click;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *is_jingxuan;

@property (nonatomic, copy) NSString *goods_desc_url;

@property (nonatomic, copy) NSString *goods_vat;

@property (nonatomic, copy) NSString *is_presell;

@property (nonatomic, copy) NSString *groupbuy_info;

@property (nonatomic, copy) NSString *evaluation_count;

@property (nonatomic, copy) NSString *goods_jingle;

@property (nonatomic, copy) NSString *virtual_invalid_refund;

@property (nonatomic, copy) NSString *is_own_shop;

@property (nonatomic, copy) NSString *plateid_top;

@property (nonatomic, copy) NSString *goods_promotion_type;

@property (nonatomic, copy) NSString *is_virtual;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *engineer_storage;

@property (nonatomic, copy) NSString *transport_title;

@property (nonatomic, copy) NSString *virtual_limit;

@property (nonatomic, copy) NSString *goods_specname;

@property (nonatomic, copy) NSString *goods_marketprice;

//@property (nonatomic, copy) NSString *copy_from;

@property (nonatomic, copy) NSString *is_fcode;

@property (nonatomic, copy) NSString *mobile_body;

@property (nonatomic, copy) NSString *appoint_satedate;

@property (nonatomic, copy) NSString *goods_promotion_price;

@property (nonatomic, copy) NSString *evaluation_good_star;

@property (nonatomic, copy) NSString *transport_id;

@property (nonatomic, copy) NSString *goods_url;

@end

@interface Goods_Attr : NSObject

@property (nonatomic, copy) NSString *name;

//@property (nonatomic, copy) NSString *175;

@end

@interface Store_Server : NSObject

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *title;


@end




