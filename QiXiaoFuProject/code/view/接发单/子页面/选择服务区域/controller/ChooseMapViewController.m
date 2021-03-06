//
//  ChooseMapViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChooseMapViewController.h"
#import "PDLocationManager.h"
#import "BlockUIAlertView.h"
#import <AMapLocationKit/AMapLocationKit.h>

#define CELL_HEIGHT                     55.f
#define CELL_COUNT                      5
#define TITLE_HEIGHT                    64.f


@interface ChooseMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AMapLocationManagerDelegate>{
    
    
    BOOL iskeyBoardShow;
    
    // 第一次定位标记
    BOOL isFirstLocated;
    // 搜索页数
//    NSInteger searchPage;
    NSString * _searchString;
    
    // 禁止连续点击两次
    BOOL _isMapViewRegionChangedFromTableView;
    
    UITableView *_searchTableView;
    
    
     AMapTip * _selectTip;// 用于保存数据
    
    AMapPOI * _selectPoi;// 用于保存数据
    
    AMapGeoPoint * _location;// 坐标
    
    BOOL _isFirstSearch;// 是否是第一次搜索
}



@property (weak, nonatomic) IBOutlet MAMapView *mapBGView; // 地图
@property (weak, nonatomic) IBOutlet UITextField *adressTextfield;
@property (weak, nonatomic) IBOutlet UIButton *locBtn;
@property (weak, nonatomic) IBOutlet UIButton *locBtn1;

@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (strong, nonatomic) AMapSearchAPI * searchAPI; // 搜索API
@property (strong, nonatomic) NSMutableArray * searchResultArray; //  // 搜索结果数组

@property (strong, nonatomic) UITableView * tableView; //  // 搜索结果数组

@property (nonatomic, copy) NSString  *city;
@property (nonatomic, copy) NSString  *address;
@property (nonatomic, copy) NSString  *lng;
@property (nonatomic, copy) NSString  *lat;

@property (nonatomic, assign) BOOL isAroundSearch;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation ChooseMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择服务区域";//  地图
    
    _isFirstSearch = YES;
    
    self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"确定" target:self action:@selector(rightTrueAction:)];
    
    _adressTextfield.delegate = self;
    [_adressTextfield addTarget:self action:@selector(adressTextfieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    _adressTextfield.returnKeyType =UIReturnKeySearch;
    
      _searchResultArray = [NSMutableArray new];
    
    [_toolView setBorder:[[UIColor grayColor] colorWithAlphaComponent:0.3] width:0.5];
    
    _mapBGView.delegate = self;
    _mapBGView.showsCompass = NO;// 不显示罗盘
    _mapBGView.showsScale = NO;// 不显示比例尺
    _mapBGView.zoomLevel = 13;// 地图缩放等级
    _mapBGView.minZoomLevel = 3;// 地图缩放等级
    _mapBGView.maxZoomLevel = 20;// 地图缩放等级

    _mapBGView.showsUserLocation = YES; // 开启定位
    
    [self actionLocation];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(_toolView.left, _toolView.bottom, kScreenWidth - 10*2, self.view.height - 10-45-216) style:UITableViewStylePlain];;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    _tableView.hidden = YES;
    
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;


    [self addNotificationkeyboard];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self actionLocation];
}


- (void)rightTrueAction:(UIBarButtonItem *)item{
    
    NSString * string = _adressTextfield.text;
    
    LxDBAnyVar(string);
    
    if(_selectPoi){
        _selectTip = [[AMapTip alloc] init];
        _selectTip.location = _selectPoi.location;
        _selectTip.name = _selectPoi.name;
        
        //直接显示输入地址
        _selectTip.name = string;
        if (_chooseSeviceAreaBlock) {
            _chooseSeviceAreaBlock(_selectTip);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (_location){
            _selectTip = [[AMapTip alloc] init];
            _selectTip.location = _location;
            _selectTip.name = string;
            
            //直接显示输入地址
            _selectTip.name = string;
            if (_chooseSeviceAreaBlock) {
                _chooseSeviceAreaBlock(_selectTip);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"定位不成功" message:@"您可能未允许使用位置，请允许使用位置" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                if (buttonIndex == 0){
                    //直接显示输入地址
                    [self actionLocation];
                    _selectTip.name = string;
                    _selectTip.location = _location;
                    if (_chooseSeviceAreaBlock) {
                        _chooseSeviceAreaBlock(_selectTip);
                    }
                    [self actionLocation];
                }else{
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]){
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            } otherButtonTitles:@"去设置"];
            [alert show];
        }
    }
}


#pragma mark -  初始化地图


#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    // 首次定位
    if (updatingLocation && !isFirstLocated) {
        [_mapBGView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        isFirstLocated = YES;
    }
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    if (!_isMapViewRegionChangedFromTableView && isFirstLocated) {
//        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapBGView.centerCoordinate.latitude longitude:_mapBGView.centerCoordinate.longitude];
//
//    }
    _isMapViewRegionChangedFromTableView = NO;
    
    [_tableView setHidden:YES];
    [self.view endEditing:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器

}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        MAUserLocation * usss = (MAUserLocation *)annotation;
        usss.title = @"我的位置";
        [mapView addAnnotation:annotation];
    }

    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"anntationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
//            annotationView.image = [UIImage imageNamed:@"msg_location"];
            annotationView.image = [UIImage imageNamed:@"wateRedBlank"];
            annotationView.canShowCallout = YES;
            annotationView.centerOffset = CGPointMake(0, -18);
            [mapView addAnnotation:annotation];
            
        }
        return annotationView;
    }
    
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{

    LxDBAnyVar(view.annotation.subtitle);
   }

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.showsAccuracyRing = NO;
        [_mapBGView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
}

#pragma mark - UITextFieldDelegate
- (void)adressTextfieldChangeAction:(UITextField *)textField{
    _searchString =textField.text;
    NSLog(@"-------   %@",_searchString);
    [self searchWithSearchDtring:textField.text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self searchWithSearchDtring:textField.text];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self searchWithSearchDtring:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    [self searchPoiBySearchString:textField.text];
    
    [self searchWithSearchDtring:textField.text];
    return YES;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellReuseIdentifier = @"searchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier];
    }
    AMapPOI *poi = [_searchResultArray objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:poi.name];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, text.length)];
    //高亮
    NSRange textHighlightRange = [poi.name rangeOfString:checkNULL(_searchString)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:textHighlightRange];
    cell.textLabel.attributedText = text;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapPOI *poi = [_searchResultArray objectAtIndex:indexPath.row];
    _selectPoi = poi;
    [_mapBGView setCenterCoordinate:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude)];
    if (self.adressTextfield.text.length == 0){
        self.adressTextfield.text = poi.name;
    }else if (poi.name.length > self.adressTextfield.text.length && [poi.name containsString:self.adressTextfield.text]){
        self.adressTextfield.text = poi.name;
    }
    
    [self.view endEditing:YES];
    
    [_mapBGView removeOverlays:_mapBGView.overlays];
    [_mapBGView removeAnnotations:_mapBGView.annotations];
    
    [self adanimtionWithLat:poi.location.latitude lon:poi.location.longitude witle:poi.name];

}

- (void)adanimtionWithLat:(CGFloat )lat lon:(CGFloat )lon witle:(NSString *)title{
    
    MAPointAnnotation * point = [[MAPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(lat, lon);
    point.title = title;
    [_mapBGView addAnnotation:point];
    
}


- (IBAction)locBtnAction:(id)sender {
    
    [self actionLocation];
}

- (IBAction)locBtn1Action:(id)sender {
    
    [self actionLocation];
    
}

#pragma mark - Action
- (void)actionLocation
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager startUpdatingLocation];
    
    _location = [AMapGeoPoint locationWithLatitude:_mapBGView.userLocation.coordinate.latitude longitude:_mapBGView.userLocation.coordinate.longitude];
    
    [_mapBGView setCenterCoordinate:_mapBGView.userLocation.coordinate animated:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
}


- (void)searchWithSearchDtring:(NSString *)searchString{
    if (searchString.length == 0){
        self.isAroundSearch = YES;
        AMapPOIAroundSearchRequest *requestPoi = [[AMapPOIAroundSearchRequest alloc] init];
        requestPoi.keywords = searchString;
        requestPoi.location = _location;
        [self.searchAPI AMapPOIAroundSearch:requestPoi];
    }else{
        self.isAroundSearch = NO;
        AMapInputTipsSearchRequest *requestTips = [[AMapInputTipsSearchRequest alloc] init];
        requestTips.keywords = searchString;
        [self.searchAPI AMapInputTipsSearch:requestTips];
    }
}



#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    _location.latitude = location.coordinate.latitude;
    _location.longitude = location.coordinate.longitude;
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查网络或者定位服务是否开启" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    } otherButtonTitles:@"去设置"];
    [alert show];
}

#pragma mark -  AMapInputTipsSearchRequest AMapSearchDelegate
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    [_searchResultArray removeAllObjects];
    
    // 添加数据并刷新TableView
    [response.tips enumerateObjectsUsingBlock:^(AMapTip *obj, NSUInteger idx, BOOL *stop) {
        DeLog(@"-------  %@--- %@-----%@----%f---%f ",obj.name,obj.district,obj.address,obj.location.latitude,obj.location.longitude)
        if (obj.location.latitude == 0) {
            if (idx + 1 < response.tips.count) {
                AMapTip * tempObj = response.tips[idx + 1];
                obj.location =tempObj.location;
                AMapPOI * poiObj = [[AMapPOI alloc] init];
                poiObj.name = obj.name;
                poiObj.location = obj.location;
                [_searchResultArray addObject:poiObj];
            }
        }else{
            AMapPOI * poiObj = [[AMapPOI alloc] init];
            poiObj.name = obj.name;
            poiObj.location = obj.location;
            [_searchResultArray addObject:poiObj];
        }
    }];
    [_tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
}


#pragma mark -  AMapPOIAroundSearchRequest AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    [_searchResultArray removeAllObjects];
    
    // 添加数据并刷新TableView
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        DeLog(@"-------  %@--- %@-----%@----%f---%f ",obj.name,obj.district,obj.address,obj.location.latitude,obj.location.longitude)
        if (obj.location.latitude == 0) {
            if (idx + 1 < response.pois.count) {
                AMapPOI * tempObj = response.pois[idx + 1];
                obj.location =tempObj.location;
                [_searchResultArray addObject:obj];
            }
        }else{
            [_searchResultArray addObject:obj];
        }
    }];
    [_tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
}


#pragma mark - 监听键盘
- (void)addNotificationkeyboard{
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    _tableView.hidden = NO;
    _tableView.frame  =CGRectMake(_toolView.left, _toolView.bottom, kScreenWidth - 10*2, self.view.height - 10-45-height);;
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
