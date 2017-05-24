//
//  PDLocationManager.m
//  PrettyFactoryProject
//
//  Created by mac on 16/6/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "PDLocationManager.h"
#import "MHTransformCorrdinate.h"
#import <AMapSearchKit/AMapSearchAPI.h>




@interface PDLocationManager ()<CLLocationManagerDelegate,AMapSearchDelegate>{

    AMapSearchAPI * _search;

}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property(assign, nonatomic) CLLocationCoordinate2D coordinate;

@end


@implementation PDLocationManager

TomatoSingletonM(PDLocationManager)

- (CLLocationManager *)locationManger
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = 100;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


- (void)location{

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [self.locationManger requestWhenInUseAuthorization];//?只在前台开启定位
        [self.locationManger requestAlwaysAuthorization];//?在后台也可定位
    }
    
    CLAuthorizationStatus status =[CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
//        UIAlertView *alvertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"需要您开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alvertView show];
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways ||
             status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locationManger startUpdatingLocation];
    }
    else {
        UIAlertView *alvertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"定位服务授权失败,请检查您的定位设置!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
}
/**
 *  授权状态发生改变时调用
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locationManger startUpdatingLocation];
    }
}
#define MHSafeString(str) (str == nil ? @"" : str)

#pragma mark---------定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * location = [locations lastObject];
    
    CLLocationCoordinate2D googleLoc = [MHTransformCorrdinate GPSLocToGoogleLoc:location.coordinate];
    
#ifdef DEBUG
    NSLog(@"纬度:gps -%g   google - %g ---  lat ---%g --- pd_lat---%g",location.coordinate.latitude,googleLoc.latitude,_latitude,[PDLocationManager sharedPDLocationManager].latitude);
    NSLog(@"经度:gps -%g   google - %g---  lon ---%g --- pd_lon---%g",location.coordinate.longitude,googleLoc.longitude,_longitude,[PDLocationManager sharedPDLocationManager].longitude);
#endif

    NSString * pd_lat = [NSString stringWithFormat:@"%g",_latitude];
    NSString * go_lat = [NSString stringWithFormat:@"%g",googleLoc.latitude];

    if (![pd_lat isEqualToString:go_lat]) {
//        
//    }
//    
//    if ([PDLocationManager sharedPDLocationManager].latitude != googleLoc.latitude) {
        
        _latitude =googleLoc.latitude;
        _longitude = googleLoc.longitude;
        
        [self searchRequestgeocoderWithLats:_latitude longs:_longitude];
    }
    _latitude =googleLoc.latitude;
    _longitude = googleLoc.longitude;

//    CLLocation *locationG = [[CLLocation alloc] initWithLatitude:googleLoc.latitude longitude:googleLoc.longitude];
//    
//    [self.geocoder reverseGeocodeLocation:locationG completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error) {
//            
//            NSLog(@"您确定还在地球上吗?");
//            
//        }
//        for (CLPlacemark *placemark in placemarks) {
//            NSDictionary *dict = placemark.addressDictionary;
//            NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@%@",
//                                 MHSafeString(placemark.administrativeArea),
//                                 MHSafeString(placemark.subAdministrativeArea),
//                                 MHSafeString(placemark.locality),
//                                 MHSafeString(placemark.subLocality),
//                                 MHSafeString(placemark.thoroughfare),
//                                 MHSafeString(placemark.subThoroughfare)];
//            
//            if (address.length == 0) {
//                address = [NSString stringWithFormat:@"%@%@",
//                           [dict objectForKey:@"Country"],
//                           [dict objectForKey:@"Name"]];
//            }
//            NSLog(@"反编码具体位置----  %@",address);
//         }
//    }];
//    
//    
//    NSLog(@"高度:%g",location.altitude);
//    NSLog(@"速度:%g",location.speed);
//    NSLog(@"方向:%g",location.course);
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败:%@",error);
}

- (void)stopLoction{
    [_locationManager stopUpdatingLocation];
    
}



- (void)searchRequestgeocoderWithLats:(double)lats longs:(double)longs{

    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:lats longitude:longs];
    request.keywords = @"";
    //    request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    
    //    request.types = @"地名地址信息";
    
    
    request.sortrule = 0;
    request.requireExtension = YES;
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];

}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            _POIName = obj.name;
             _adcode = obj.citycode;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationManager" object:nil];
            
//            [self stopLoction];
            
         }
    }];
}



@end
