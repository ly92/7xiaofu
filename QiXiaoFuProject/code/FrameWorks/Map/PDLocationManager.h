//
//  PDLocationManager.h
//  PrettyFactoryProject
//
//  Created by mac on 16/6/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import "TomatoSingleton.h"

@interface PDLocationManager : NSObject
//单例模式，只要获取到了坐标，全局都可以使用这个坐标
TomatoSingletonH(PDLocationManager)

@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (strong, nonatomic) NSString *streetAddress;//地址

@property (strong, nonatomic) NSString * POIName;
 @property (strong, nonatomic) NSString * adcode;

//获取坐标
- (void)location;

- (void)stopLoction;

@end
