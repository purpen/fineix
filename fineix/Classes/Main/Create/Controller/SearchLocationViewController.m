//
//  SearchLocationViewController.m
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchLocationViewController.h"

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
    
    _poiSearch = [[BMKPoiSearch alloc] init];
    _locationSearch = [[BMKLocationService alloc] init];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];

    [self setNavViewUI];
    
    [self.view addSubview:self.searchView];
    
    [self.view addSubview:self.locationTableView];
    
    [_locationSearch startUserLocationService];
    
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"位置"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addLine];
    [self.navView addSubview:self.positioningBtn];
    [self.navView addSubview:self.cancelVCBtn];
}

#pragma mark - 定位按钮
- (UIButton *)positioningBtn {
    if (!_positioningBtn) {
        _positioningBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_positioningBtn setImage:[UIImage imageNamed:@"Location Indicator"] forState:(UIControlStateNormal)];
        [_positioningBtn addTarget:self action:@selector(positioningBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _positioningBtn;
}

- (void)positioningBtnClick {
    NSLog(@"==== %f ---- %f", _locationSearch.userLocation.location.coordinate.longitude, _locationSearch.userLocation.location.coordinate.latitude);
    [SVProgressHUD showInfoWithStatus:@"获取当前定位"];
}

#pragma mark - 取消按钮
- (UIButton *)cancelVCBtn {
    if (!_cancelVCBtn) {
        _cancelVCBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_cancelVCBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _cancelVCBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        [self.cancelVCBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [self.cancelVCBtn addTarget:self action:@selector(cancelVCBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelVCBtn;
}

- (void)cancelVCBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜素框
- (FBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 44)];
        _searchView.searchInputBox.placeholder = @"搜索地点";
        _searchView.delegate = self;
    }
    return _searchView;
}

- (void)beginSearch:(NSString *)searchKeyword {
    NSLog(@"开始搜索地点======== %@", searchKeyword);
    [self beginSearchLocation:searchKeyword];
}

#pragma mark - 搜索地理位置
- (void)beginSearchLocation:(NSString *)locationKeyword {
//    num = 0;
    BMKNearbySearchOption * nearbySearchOption = [[BMKNearbySearchOption alloc] init];
//    nearbySearchOption.pageIndex = num;
//    nearbySearchOption.radius = 10000;
    nearbySearchOption.pageCapacity = 10;
    nearbySearchOption.location = CLLocationCoordinate2DMake(_locationSearch.userLocation.location.coordinate.longitude, _locationSearch.userLocation.location.coordinate.latitude);  //  中心点
    NSLog(@"==== %f ---- %f", _locationSearch.userLocation.location.coordinate.longitude, _locationSearch.userLocation.location.coordinate.latitude);
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
            BMKPoiInfo * poi = [poiResult.poiInfoList objectAtIndex:0];
            NSLog(@"＝＝＝搜索的结果：  %@", poi.name);
    
    } else {
        NSLog(@"搜索结果错误 －－－－－ %d", errorCode);
    }
}

#pragma mark - 搜索地理位置列表
- (UITableView *)locationTableView {
    if (!_locationTableView) {
        _locationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, SCREEN_HEIGHT-94) style:(UITableViewStylePlain)];
        _locationTableView.showsHorizontalScrollIndicator = NO;
        _locationTableView.showsVerticalScrollIndicator = NO;
        _locationTableView.bounces = NO;
        _locationTableView.delegate = self;
        _locationTableView.dataSource = self;
    }
    return _locationTableView;
}

#pragma mark - tableViewDelegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * locationTableViewCellID = @"locationTableViewCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:locationTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:locationTableViewCellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zi个",indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"哈哈哈哈哈哈 %zi",indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:grayLineColor alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - 选中位置
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
    self.selectedLocationBlock([tableView cellForRowAtIndexPath:indexPath].textLabel.text,
                               [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text);
    NSLog(@"选中了====== 位置%zi", indexPath.row);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _poiSearch.delegate = nil;
    _locationSearch.delegate = nil;
}

- (void)dealloc {
    if (_poiSearch.delegate != nil) {
        _poiSearch.delegate = nil;

    }
    if (_locationSearch.delegate != nil) {
        _locationSearch.delegate = nil;
    }
}

@end
