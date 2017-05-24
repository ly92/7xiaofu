//
//  MKMapView+MapViewUtil.h
//  QiXiaoFuProject
//
//  Created by mac on 2017/2/16.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (MapViewUtil)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
