//
//  SearchLocationViewController.m
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchLocationViewController.h"
#import "SVProgressHUD.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "MapAnnotionViewController.h"
#define MAPHEGHIT 100
#define TABLEVIEW_Y (self.searchView.frame.origin.y + self.searchView.frame.size.height)
@interface SearchLocationViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,MapannotionDelegate,UIAlertViewDelegate>
{
    BOOL _flag;
}
/** 地图 */
@property (nonatomic, strong) BMKMapView *mapView;
/** 地图点击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *mapTap;
@end

@implementation SearchLocationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _poiSearch.delegate = self;
    _locationSearch.delegate = self;
    _geoCodeSearch.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavViewUI];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.locationTableView];
    [self initLocationMarr];
    [self.view addSubview:self.mapView];
    //  判断是否开启GPS定位
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"openGPS", nil)];
            _flag = NO;
        }else{
            [self initBMKService];
            [SVProgressHUD showWithStatus:NSLocalizedString(@"searchLocationing", nil)];
            _flag = YES;
        }
        
    } else {
        
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reciveInfo:) name:@"b" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    if (_flag) {
        return;
    }
    NSString *mediaMessage = @"请在设置->隐私->定位服务 中打开本应用的访问权限并在返回后重新打开该页面";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:mediaMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.delegate = self;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
    
}

-(void)reciveInfo:(NSNotification*)sender{
    NSDictionary *dict = sender.userInfo;
    self.locationNameMarr = dict[@"name"];
    self.locationCityMarr = dict[@"city"];
    self.latitudeMarr = dict[@"lat"];
    self.longitudeMarr = dict[@"lon"];
    self.locationAddressMarr = dict[@"add"];
    [self.locationTableView reloadData];
    [self.mapView removeAnnotations:self.mapView.annotations];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = [dict[@"lat1"] doubleValue];
    coor.longitude = [dict[@"lon1"] doubleValue];
    annotation.coordinate = coor;
    [self.mapView addAnnotation:annotation];
    self.mapView.centerCoordinate = coor;
}


-(UITapGestureRecognizer *)mapTap{
    if (!_mapTap) {
        _mapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMap)];
    }
    return _mapTap;
}

-(void)tapMap{
    MapAnnotionViewController *vc = [[MapAnnotionViewController alloc] init];
    vc.nameAry = self.locationNameMarr;
    vc.latAry = self.latitudeMarr;
    vc.lonAry = self.longitudeMarr;
    vc.cityAry = self.locationCityMarr;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}


-(void)mapAnnoWithName:(NSString *)name andCity:(NSString *)city andLat:(NSString *)lat andLon:(NSString *)lon{
    if ([self.delegeta respondsToSelector:@selector(searchLocationWithName:andCity:andLat:andLon:)]) {
        [self.delegeta searchLocationWithName:name andCity:city andLat:lat andLon:lon];
    }
}

-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-MAPHEGHIT, SCREEN_WIDTH, MAPHEGHIT)];
        _mapView.zoomLevel = 15;
        _mapView.delegate = self;
        [_mapView addGestureRecognizer:self.mapTap];
        //添加渐变层
        CAGradientLayer * shadow = [CAGradientLayer layer];
        shadow.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
        shadow.opacity = 0.3;
        shadow.startPoint = CGPointMake(0, 1);
        shadow.endPoint = CGPointMake(0, 0);
        shadow.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
        [_mapView.layer addSublayer:shadow];
    }
    return _mapView;
}


#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"locationVcTitle", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addLine];
    [self.navView addSubview:self.positioningBtn];
    [self.navView addSubview:self.cancelVCBtn];
}

#pragma mark - 重新定位按钮
- (UIButton *)positioningBtn {
    if (!_positioningBtn) {
        _positioningBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_positioningBtn setImage:[UIImage imageNamed:@"Location Indicator Icon"] forState:(UIControlStateNormal)];
        [_positioningBtn addTarget:self action:@selector(positioningBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _positioningBtn;
}

- (void)positioningBtnClick {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"againLocationing", nil)];
    _searchView.searchInputBox.text = @"";
    [self setDefaultLocation];
}

#pragma mark - 取消按钮
- (UIButton *)cancelVCBtn {
    if (!_cancelVCBtn) {
        _cancelVCBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_cancelVCBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _cancelVCBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        [self.cancelVCBtn setTitle:NSLocalizedString(@"cancel", nil) forState:(UIControlStateNormal)];
        [self.cancelVCBtn addTarget:self action:@selector(cancelVCBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelVCBtn;
}

- (void)cancelVCBtnClick {
    if ([self.type isEqualToString:@"release"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.type isEqualToString:@"edit"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 初始化百度地图服务
- (void)initBMKService {
    _poiSearch = [[BMKPoiSearch alloc] init];
    _locationSearch = [[BMKLocationService alloc] init];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];

    //  开始定位
    [_locationSearch startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    latitude = _locationSearch.userLocation.location.coordinate.latitude;
    longitude = _locationSearch.userLocation.location.coordinate.longitude;
    
    [self setDefaultLocation];
    
    [_locationSearch stopUserLocationService];
    _mapView.showsUserLocation = YES;
    [_mapView updateLocationData:userLocation];
    [_locationSearch stopUserLocationService];
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

#pragma mark - 默认搜索周边位置
- (void)setDefaultLocation {
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = CLLocationCoordinate2DMake(latitude, longitude);
    [_geoCodeSearch reverseGeoCode:option];
}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        [self.locationNameMarr removeAllObjects];
        [self.locationCityMarr removeAllObjects];
        [self.locationAddressMarr removeAllObjects];
        [self.latitudeMarr removeAllObjects];
        [self.longitudeMarr removeAllObjects];
        
        for (NSUInteger idx = 0; idx < result.poiList.count; ++ idx) {
            BMKPoiInfo * poi = [result.poiList objectAtIndex:idx];
            [self.locationNameMarr addObject:poi.name];
            [self.locationCityMarr addObject:poi.city];
            [self.locationAddressMarr addObject:poi.address];
            [self.latitudeMarr addObject:[NSString stringWithFormat:@"%f", poi.pt.latitude]];
            [self.longitudeMarr addObject:[NSString stringWithFormat:@"%f", poi.pt.longitude]];
        }
        [self.locationTableView reloadData];
        [SVProgressHUD dismiss];
        if (self.latitudeMarr.count > 0) {
            self.mapView.centerCoordinate = CLLocationCoordinate2DMake([self.latitudeMarr[0] doubleValue], [self.longitudeMarr[0] doubleValue]);
        }
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[self.latitudeMarr firstObject] doubleValue];
        coor.longitude = [[self.longitudeMarr firstObject] doubleValue];
        annotation.coordinate = coor;
        [self.mapView addAnnotation:annotation];
    } else if (error == BMK_SEARCH_NETWOKR_ERROR) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"netError", nil)];
    
    }else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"searchLocationError", nil)];
    }
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        return newAnnotationView;
    }
    return nil;
}


#pragma mark - 初始化保存地理位置的数组
- (void)initLocationMarr {
    self.locationNameMarr = [NSMutableArray array];
    self.locationCityMarr = [NSMutableArray array];
    self.locationAddressMarr = [NSMutableArray array];
    self.latitudeMarr = [NSMutableArray array];
    self.longitudeMarr = [NSMutableArray array];
}

#pragma mark - 搜素框
- (FBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 44)];
        _searchView.cancelBtn.hidden = YES;
        _searchView.backgroundColor = [UIColor whiteColor];
        [_searchView.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-30, 30));
            make.centerY.equalTo(_searchView);
            make.left.equalTo(_searchView.mas_left).with.offset(15);
        }];
        _searchView.searchInputBox.placeholder = NSLocalizedString(@"searchLocation", nil);
        _searchView.delegate = self;
    }
    return _searchView;
}

- (void)beginSearch:(NSString *)searchKeyword {
    if ([searchKeyword isEqualToString:@""]) {
        NSLog(@"搜索词为空，不搜索");
        
    } else {
        [self.locationNameMarr removeAllObjects];
        [self.locationCityMarr removeAllObjects];
        [self.locationAddressMarr removeAllObjects];
        [self.latitudeMarr removeAllObjects];
        [self.longitudeMarr removeAllObjects];
        
        [self beginSearchLocation:searchKeyword];
    }
}

#pragma mark - 搜索地理位置
- (void)beginSearchLocation:(NSString *)locationKeyword {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"searchLocationing", nil)];
    BMKNearbySearchOption * nearbySearchOption = [[BMKNearbySearchOption alloc] init];
    nearbySearchOption.pageCapacity = 100;
    nearbySearchOption.radius = 1410065408;
    nearbySearchOption.location = CLLocationCoordinate2DMake(latitude, longitude);
    nearbySearchOption.sortType = BMK_POI_SORT_BY_DISTANCE;
    nearbySearchOption.keyword = locationKeyword;
    BOOL flag = [_poiSearch poiSearchNearBy:nearbySearchOption];
    if (flag) {
        NSLog(@"搜索成功");
    } else {
        NSLog(@"搜索失败");
    }
}

#pragma mark - 地图搜索的delegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        for (NSUInteger idx = 0; idx < poiResult.poiInfoList.count; ++ idx) {
            BMKPoiInfo * poi = [poiResult.poiInfoList objectAtIndex:idx];
            [self.locationNameMarr addObject:poi.name];
            [self.locationCityMarr addObject:poi.city];
            [self.locationAddressMarr addObject:poi.address];
            [self.latitudeMarr addObject:[NSString stringWithFormat:@"%f", poi.pt.latitude]];
            [self.longitudeMarr addObject:[NSString stringWithFormat:@"%f", poi.pt.longitude]];
        }
        [self.locationTableView reloadData];
        [SVProgressHUD dismiss];
        [self.mapView removeAnnotations:self.mapView.annotations];
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[self.latitudeMarr firstObject] doubleValue];
        coor.longitude = [[self.longitudeMarr firstObject] doubleValue];
        annotation.coordinate = coor;
        [self.mapView addAnnotation:annotation];
    } else if (errorCode == BMK_SEARCH_NETWOKR_ERROR) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"netError", nil)];
        
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"searchLocationError", nil)];
    }
}

#pragma mark - 搜索地理位置列表
- (UITableView *)locationTableView {
    if (!_locationTableView) {
        _locationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,TABLEVIEW_Y , SCREEN_WIDTH, SCREEN_HEIGHT-MAPHEGHIT-TABLEVIEW_Y)];
        _locationTableView.showsHorizontalScrollIndicator = NO;
        _locationTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        _locationTableView.showsVerticalScrollIndicator = NO;
        _locationTableView.bounces = YES;
        _locationTableView.delegate = self;
        _locationTableView.dataSource = self;
        _locationTableView.backgroundColor = [UIColor colorWithHexString:grayLineColor alpha:1];
//        _locationTableView.tableFooterView = [[UIView alloc] init];
    }
    return _locationTableView;
}

#pragma mark - tableViewDelegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationNameMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * locationTableViewCellID = @"locationTableViewCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:locationTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:locationTableViewCellID];
    }
    cell.textLabel.text = self.locationNameMarr[indexPath.row];
    cell.detailTextLabel.text = self.locationAddressMarr[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:titleColor];
    cell.backgroundColor = [UIColor colorWithHexString:grayLineColor alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - 选中位置
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedLocationBlock(self.locationNameMarr[indexPath.row], self.locationCityMarr[indexPath.row], self.latitudeMarr[indexPath.row], self.longitudeMarr[indexPath.row]);
    
    if ([self.type isEqualToString:@"release"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.type isEqualToString:@"edit"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _poiSearch.delegate = nil;
    _locationSearch.delegate = nil;
    _geoCodeSearch.delegate = nil;
    
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    if (_poiSearch.delegate != nil) {
        _poiSearch.delegate = nil;
    }
    if (_locationSearch.delegate != nil) {
        _locationSearch.delegate = nil;
    }
    if (_geoCodeSearch.delegate != nil) {
        _geoCodeSearch.delegate = nil;
    }
    self.mapView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"b" object:nil];
}

@end
