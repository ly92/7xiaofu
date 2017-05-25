//
//  SpaceTimeModel.h
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/5/25.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpaceTimeModel : NSObject
//{
//    service_sector = 	(
//    ),
//    tack_address = ",北京市青尚办公区,",
//    tack_citys = ",北京市,",
//    service_stime = "1495612080000",
//    tack_lngs = ",116.337281,",
//    member_id = "995",
//    tack_lats = ",40.041739,",
//    service_etime = "1495622880000",
//    tack_arrays = 	(
//                     {
//                         lng = 116.337281,
//                         lat = 40.041739,
//                         city = "北京市青尚办公区",
//                         address = "北京市青尚办公区",
//                     },
//                     ),
//}
@property (nonatomic, copy) NSString *tack_address;
@property (nonatomic, copy) NSString *tack_citys;
@property (nonatomic, copy) NSString *service_stime;
@property (nonatomic, copy) NSString *tack_lngs;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *tack_lats;
@property (nonatomic, copy) NSString *service_etime;
@property (nonatomic, copy) NSString *service_sector;
@property (nonatomic, strong) NSArray *tack_arrays;

@end

@interface TackModel : NSObject
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *address;

@end
