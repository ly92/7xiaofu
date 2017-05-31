//
//  MatchingEngineerListMapVC.m
//  QiXiaoFuProject
//
//  Created by mac on 16/12/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MatchingEngineerListMapVC.h"

#import "EngineerModel.h"

#import <MapKit/MapKit.h>
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "MatchingEngineerMapView.h"
#import "ChatViewController.h"


@interface MatchingEngineerListMapVC ()<MKMapViewDelegate>{
    
    
    UIView  * mapbgView ;
    
    BOOL numFlag;
    
    MKMapView *_mapView;
    CalloutMapAnnotation *_calloutAnnotation;
    CalloutMapAnnotation *_previousdAnnotation;
    
    
}


@end

@implementation MatchingEngineerListMapVC



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        numFlag = YES;
        
        
        mapbgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)];
        mapbgView.backgroundColor = [UIColor redColor];
        [self.view addSubview:mapbgView];
        
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, mapbgView.width, mapbgView.height)];
        _mapView.delegate = self;
        [mapbgView addSubview:_mapView];
        _mapView.showsUserLocation = YES;
        _mapView.userInteractionEnabled = YES;
        
    }
    return self;
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setMapItemArray:(NSArray *)mapItemArray{
    _mapItemArray = mapItemArray;
    
//    NSMutableArray * da = [NSMutableArray new];
//    
//    [da addObjectsFromArray:_mapItemArray];
//    [da addObjectsFromArray:_mapItemArray];
//    [da addObjectsFromArray:_mapItemArray];
//    [da addObjectsFromArray:_mapItemArray];
//    [da addObjectsFromArray:_mapItemArray];
//    [da addObjectsFromArray:_mapItemArray];
//    [da addObjectsFromArray:_mapItemArray];
//    [da addObjectsFromArray:_mapItemArray];
//    [da addObjectsFromArray:_mapItemArray];
//    [da addObjectsFromArray:_mapItemArray];
//    
//    _mapItemArray = [NSArray arrayWithArray:da];
    
    for (NSInteger i = 0; i < _mapItemArray.count; i ++) {
        EngineerModel * bdModel = _mapItemArray[i];
        CLLocationDegrees latitude= [bdModel.lat doubleValue];//44 + i;//
        CLLocationDegrees longitude= [bdModel.lng doubleValue];//116 + i;//
        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
        annotation.titles= @"123";
        annotation.tag = i;
        [_mapView addAnnotation:annotation];
    }
}




- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
        
        BasicMapAnnotation * anaa =(BasicMapAnnotation *)view.annotation;
        
        //#ifdef DEBUG
        //        NSLog(@"冯洪建的打印数据--dianle ---- %ld",(long)anaa.tag);
        //#endif
        //        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
        //            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
        //            return;
        //        }
        //        if (_calloutAnnotation) {
        //            [_mapView removeAnnotation:_calloutAnnotation];
        //            _calloutAnnotation = nil;
        //        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc]
                              initWithLatitude:view.annotation.coordinate.latitude
                              andLongitude:view.annotation.coordinate.longitude];
        
        _calloutAnnotation.tag =anaa.tag;
        [_mapView addAnnotation:_calloutAnnotation];
        [_mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
    }
    else{
        //        if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)]){
        //            [delegate customMKMapViewDidSelectedWithInfo:@"点击至之后你要在这干点啥"];
        //        }
        
        
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation&& ![view isKindOfClass:[MatchingEngineerMapView class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [_mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    LxDBAnyVar(annotation);
    
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        
        MatchingEngineerMapView *annotationView = (MatchingEngineerMapView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        //        if (!annotationView) {
        annotationView = [[MatchingEngineerMapView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
        
        CalloutMapAnnotation * anaa =(CalloutMapAnnotation *)annotation;
        EngineerModel * bdModel = _mapItemArray[anaa.tag];
        [annotationView loadDataWithModel:bdModel];
        //        }
        return annotationView;
    } else if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
        MKAnnotationView *annotationView =[_mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"wateRedBlank"];
            
        }
        
        return annotationView;
    }
    return nil;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D _coordinate;
    _coordinate.latitude = userLocation.location.coordinate.latitude;
    _coordinate.longitude = userLocation.location.coordinate.longitude;
    if (numFlag == YES) {
        [self setMapRegionWithCoordinate:_coordinate];
    }
}

//减少内存占用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [_mapView removeFromSuperview];
    [mapbgView addSubview:mapView];
}

- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    numFlag = NO;
    MKCoordinateRegion region;
    //    region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1, 0.1));
    region=MKCoordinateRegionMakeWithDistance(coordinate,1609.344 ,1609.344 );
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:adjustedRegion animated:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
