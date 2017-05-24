//
//  YWNetworkStatusManager.h
//  YiWangClient
//
//  Created by DarkAngel on 15/10/8.
//  Copyright © 2015年 一网全城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YWNetworkStatus) {
    YWNetworkStatusUnknown          = -1,   //不知名网络
    YWNetworkStatusNone             = 0,    //没有网络
    YWNetworkStatusWifi             = 1,    //WIFI网络
    YWNetworkStatusCDMA1x           = 2,    //电信2.75G网络
    YWNetworkStatusCDMAEVDORev0     = 3,    //电信3G Rev0
    YWNetworkStatusCDMAEVDORevA     = 4,    //电信3G RevA
    YWNetworkStatusCDMAEVDORevB     = 5,    //电信3G RevB
    YWNetworkStatusEdge             = 6,    //移动/联通E网 (2.75G网络)
    YWNetworkStatusGPRS             = 7,    //移动/联通GPRS(2G网络)
    YWNetworkStatusHSDPA            = 8,    //移动/联通3G网络  (虽然移动用的是td而不是wcdma但也算是3G)
    YWNetworkStatusHSUPA            = 9,    //移动/联通3G网络
    YWNetworkStatusWCDMA            = 10,   //3G网络
    YWNetworkStatusHRPD             = 11,   //电信CDMA网络
    YWNetworkStatusLTE              = 12    //4G网络
    //大类：0没有网络 1为WIFI网络 2/6/7为2G网络  3/4/5/8/9/10/11为3G网络  12为4G网络 -1为不知名网络
};


@interface YWNetworkStatusManager : NSObject

/*!
 *  获取当前的网络状态。注意：不要在主线程调用，请异步调用
 *
 *  @return 状态。
 */
+ (YWNetworkStatus)currentNetworkStatus;


@end
