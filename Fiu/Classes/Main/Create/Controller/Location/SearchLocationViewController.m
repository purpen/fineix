//
//  SearchLocationViewController.m
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchLocationViewController.h"
#import "SVProgressHUD.h"

@interface SearchLocationViewController ()

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
    
    //  判断是否开启GPS定位
    if ([CLLocationManager locationServicesEnabled]) {
        [self initBMKService];
        [SVProgressHUD showWithStatus:NSLocalizedString(@"searchLocationing", nil)];
        
    } else {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"openGPS", nil)];
    }
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
    [self.navigationController popViewControllerAnimated:YES];
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
        
    } else if (error == BMK_SEARCH_NETWOKR_ERROR) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"netError", nil)];
    
    }else {
        NSLog(@"搜索结果错误 －－－－－ %d", error);
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"searchLocationError", nil)];
    }
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
    nearbySearchOption.radius = 10000;
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
    
    } else if (errorCode == BMK_SEARCH_NETWOKR_ERROR) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"netError", nil)];
        
    } else {
        NSLog(@"搜索结果错误 －－－－－ %d", errorCode);
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"searchLocationError", nil)];
    }
}

#pragma mark - 搜索地理位置列表
- (UITableView *)locationTableView {
    if (!_locationTableView) {
        _locationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, SCREEN_HEIGHT-94) style:(UITableViewStylePlain)];
        _locationTableView.showsHorizontalScrollIndicator = NO;
        _locationTableView.showsVerticalScrollIndicator = NO;
        _locationTableView.bounces = YES;
        _locationTableView.delegate = self;
        _locationTableView.dataSource = self;
        _locationTableView.backgroundColor = [UIColor colorWithHexString:grayLineColor alpha:1];
        _locationTableView.tableFooterView = [[UIView alloc] init];
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
    return 70;
}

#pragma mark - 选中位置
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedLocationBlock(self.locationNameMarr[indexPath.row], self.locationCityMarr[indexPath.row], self.latitudeMarr[indexPath.row], self.longitudeMarr[indexPath.row]);
     [self.navigationController popViewControllerAnimated:YES];
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
}

@end
