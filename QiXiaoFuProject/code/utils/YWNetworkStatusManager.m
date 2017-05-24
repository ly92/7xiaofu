//
//  YWNetworkStatusManager.m
//  YiWangClient
//
//  Created by DarkAngel on 15/10/8.
//  Copyright © 2015年 一网全城. All rights reserved.
//

#import "YWNetworkStatusManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "Reachability.h"

@implementation YWNetworkStatusManager

/*!
 *  获取当前的网络状态。注意：不要在主线程调用，请异步调用
 *
 *  @return 状态。
 */
+ (YWNetworkStatus)currentNetworkStatus
{
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            return YWNetworkStatusNone;
        case ReachableViaWiFi:
            return YWNetworkStatusWifi;
        case ReachableViaWWAN:
            return [YWNetworkStatusManager WWANNetworkStatus];
        default:
            return YWNetworkStatusUnknown;
    }
}

/*!
 *  获取流量的链接状态类型
 *
 *  @return 网络链接状态
 */
+ (YWNetworkStatus)WWANNetworkStatus
{
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];
    NSString *currentStatus  = networkStatus.currentRadioAccessTechnology;
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
        //GPRS网络
        return YWNetworkStatusGPRS;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
        //2.75G的EDGE网络
        return YWNetworkStatusEdge;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        //3G WCDMA网络
        return YWNetworkStatusWCDMA;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        //3.5G网络
        return YWNetworkStatusHSDPA;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        //3.5G网络
        return YWNetworkStatusHSUPA;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        //CDMA2G网络
        return YWNetworkStatusCDMA1x;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        //CDMA的EVDORev0(应该算3G吧?)
        return YWNetworkStatusCDMAEVDORev0;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        //CDMA的EVDORevA(应该也算3G吧?)
        return YWNetworkStatusCDMAEVDORevA;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        //CDMA的EVDORev0(应该还是算3G吧?)
        return YWNetworkStatusCDMAEVDORevB;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        //HRPD网络
        return YWNetworkStatusHRPD;
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        //LTE4G网络
        return YWNetworkStatusLTE;
    }
    /*==
     取运营商名字  Objective.subscriberCellularProvider.carrierName
     */
    return YWNetworkStatusUnknown;
}

@end
