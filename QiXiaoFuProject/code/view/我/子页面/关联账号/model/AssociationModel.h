//
//  AssociationModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User_To_Me,Me_To_User,AZi;
@interface AssociationModel : NSObject

@property (nonatomic, strong) NSArray<Me_To_User *> *me_to_user;

@property (nonatomic, strong) User_To_Me *user_to_me;

@end

@interface User_To_Me : NSObject

@property (nonatomic, copy) NSString *member_avatar;

@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, copy) NSString *inputtime;

@property (nonatomic, copy) NSString *to_user_name;

@property (nonatomic, copy) NSString *member_name;

@property (nonatomic, copy) NSString *jibie;


@end


@interface Me_To_User : NSObject

@property (nonatomic, copy) NSString *member_avatar;

@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, copy) NSString *inputtime;

@property (nonatomic, copy) NSString *to_user_name;

@property (nonatomic, copy) NSString *member_name;

@property (nonatomic, copy) NSString *jibie;

@property (nonatomic, strong) NSArray<AZi *> *zi;

@property (nonatomic, copy) NSString *level1_id;
@property (nonatomic, copy) NSString *level2_id;
@property (nonatomic, copy) NSString *level3_id;



@end


@interface AZi : NSObject
@property (nonatomic, copy) NSString *member_avatar;

@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, copy) NSString *inputtime;

@property (nonatomic, copy) NSString *member_name;

/*
member_areaid = <null>,
tack_address = "",
real_img2 = "http://10.216.2.11/UPLOAD/sys/2017-05-27/~UPLOAD~sys~2017-05-27@1495877383.png",
cer_image1 = "",
is_real = "1",
cer_image3_name = "",
zhengshu2 = "",
available_rc_balance = "0.00",
id = "1008",
real_type3 = "",
member_time = "1495876429",
tack_lngs = "",
member_points = "0",
member_birthday = <null>,
cer_image4 = "",
zhengshu5 = "",
thumb = "",
member_old_login_time = "1495876429",
service_brand = "",
style = <null>,
working_time = "0",
member_avatar = <null>,
member_qqopenid = <null>,
is_buy = "1",
baby_parents = "",
member_mobile = "18612334013",
member_old_login_ip = "192.168.1.41",
member_sinaopenid = <null>,
member_cityid = <null>,
member_provinceid = <null>,
member_privacy = <null>,
cer_image4_name = "",
member_passwd = "96e79218965eb72c92a549dd5a330112",
member_email = "",
fenxiao_shanginfo = "",
real_img1 = "http://10.216.2.11/UPLOAD/sys/2017-05-27/~UPLOAD~sys~2017-05-27@1495877379.png",
member_truename = "勇",
service_etime = "0",
inputtime = "1495876429",
member_login_num = "1",
member_qqinfo = <null>,
member_sinainfo = <null>,
member_state = "1",
zhengshu1 = "",
real_type1 = "",
cer_image2 = "",
feixiao_xrenshu = "",
tack_citys = "",
member_ww = <null>,
member_name_wanneng = "",
service_stime = "0",
real_time = "1495877398",
inform_allow = "1",
zc_price = "0.00",
zhengshu4 = "",
member_level = "2",
real_type4 = "",
tack_lats = "",
member_sex = <null>,
member_name = "18612334013",
inviter_id = "1006",
cer_image5 = "",
cer_image5_name = "",
member_tags = "",
member_exppoints = "0",
is_allowtalk = "1",
baby_sex = <null>,
level1_id = "1006",
is_storeself = "0",
id_card = "457643245667763377",
member_mobile_bind = "1",
weixin_unionid = <null>,
cer_image1_name = "",
freeze_rc_balance = "0.00",
service_sector = "",
member_id = "1008",
fenxiao_level = "",
member_areainfo = <null>,
tack_geo = "",
level2_id = "1008",
member_qq = <null>,
weixin_info = <null>,
catid = "0",
member_nik_name = "13",
real_type2 = "",
zhengshu3 = "",
is_recommended = "0",
title = "",
freeze_predeposit = "0.00",
cer_image3 = "",
available_predeposit = "99721.80",
level3_id = "0",
member_email_bind = "0",
real_type5 = "",
listorder = "0",
tack_arrays = "",
cer_image2_name = "",
member_zs_name = "",
baby_birthday = <null>,
member_login_time = "1495876429",
member_paypwd = "96e79218965eb72c92a549dd5a330112",
member_login_ip = "192.168.1.41",
baby_star = "",
member_quicklink = <null>,
bind_store_id = "1",
member_snsvisitnum = "0",
*/
 
@end

