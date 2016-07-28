//
//  MapAnnotionViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/7/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MapAnnotionViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "ReleaseViewController.h"
#import "SearchLocationViewController.h"
#define MAP_TOP 125

@interface MapAnnotionViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    CLLocationCoordinate2D _pt;
    NSString *_subTitle;
}
/** 地图 */
@property (nonatomic, strong) BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
/** 定位 */
@property (nonatomic, strong) BMKLocationService *location;
/** 大头针 */
@property (nonatomic, strong) UIImageView *annoImageView;
/** 反向地理编码 */
@property (nonatomic, strong) BMKGeoCodeSearch *searcher;
/**  */
@property (nonatomic, strong) UIButton *positioningBtn;
/**  */
@property (nonatomic, strong) UIButton *cancelVCBtn;
/**  */
@property (nonatomic, strong) NSMutableArray *addressAry;

@end

@implementation MapAnnotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"locationVcTitle", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addLine];
    [self.navView addSubview:self.positioningBtn];
    [self.navView addSubview:self.cancelVCBtn];

    [self.view addSubview:self.mapView];
    _locationLabel.text = self.nameAry[0];
    [self.location startUserLocationService];
    [self.view addSubview:self.annoImageView];
    self.annoImageView.center = self.mapView.center;
}

-(NSMutableArray *)addressAry{
    if (!_addressAry) {
        _addressAry = [[NSMutableArray alloc] init];
    }
    return _addressAry;
}

#pragma mark - 重新定位按钮
- (UIButton *)positioningBtn {
    if (!_positioningBtn) {
        _positioningBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_positioningBtn setImage:[UIImage imageNamed:@"icon_back"] forState:(UIControlStateNormal)];
        [_positioningBtn addTarget:self action:@selector(positioningBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _positioningBtn;
}

- (void)positioningBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 取消按钮
- (UIButton *)cancelVCBtn {
    if (!_cancelVCBtn) {
        _cancelVCBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_cancelVCBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _cancelVCBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_ControllerTitle];
        } else {
            _cancelVCBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        }
        [self.cancelVCBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [self.cancelVCBtn addTarget:self action:@selector(cancelVCBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        _cancelVCBtn.enabled = NO;
        [_cancelVCBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _cancelVCBtn;
}

- (void)cancelVCBtnClick {
    NSNotification * notice =[NSNotification notificationWithName:@"b" object:nil userInfo:@{
                                                                                             @"name":self.nameAry,
                                                                                             @"city":self.cityAry,
                                                                                             @"lat":self.latAry,
                                                                                             @"lon":self.lonAry,
                                                                                             @"add":self.addressAry,
                                                                                             @"lat1":@(_pt.latitude),
                                                                                             @"lon1":@(_pt.longitude)
                                                                                             }];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//  分割线
- (void)addLine {
    [self.navView addSubview:self.line];
}


-(BMKGeoCodeSearch *)searcher{
    if (!_searcher) {
        _searcher = [[BMKGeoCodeSearch alloc] init];
        _searcher.delegate = self;
    }
    return _searcher;
}

-(UIImageView *)annoImageView{
    if (!_annoImageView) {
        _annoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 45)];
        _annoImageView.image = [UIImage imageNamed:@"icon_map_dark"];
    }
    return _annoImageView;
}


-(BMKLocationService *)location{
    if (!_location) {
        _location = [[BMKLocationService alloc] init];
        _location.delegate = self;
    }
    return _location;
}

-(void)rightBarItemSelected{
//    self.selectedLocationBlock(nil, nil, nil, nil);
//   [self.navigationController popViewControllerAnimated:YES];
    
}

-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, MAP_TOP, SCREEN_WIDTH, SCREEN_HEIGHT-MAP_TOP)];
        _mapView.zoomLevel = 18;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.centerCoordinate = CLLocationCoordinate2DMake([self.latAry[0] doubleValue], [self.lonAry[0] doubleValue]);
    }
    return _mapView;
}

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    CGPoint center = CGPointMake(self.view.center.x, self.view.center.y-MAP_TOP*0.5);
    CLLocationCoordinate2D pt = [self.mapView convertPoint:center toCoordinateFromView:self.mapView];
    _pt = pt;
    
    BMKReverseGeoCodeOption *reverGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverGeoCodeSearchOption.reverseGeoPoint = pt;
    [self.searcher reverseGeoCode:reverGeoCodeSearchOption];
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (result.poiList.count) {
        [self.nameAry removeAllObjects];
        [self.cityAry removeAllObjects];
        [self.latAry removeAllObjects];
        [self.lonAry removeAllObjects];
        [self.addressAry removeAllObjects];
        self.cancelVCBtn.enabled = YES;
        [_cancelVCBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.locationLabel.text = ((BMKPoiInfo *)result.poiList[0]).name;
        [result.poiList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BMKPoiInfo *info = obj;
            [self.nameAry addObject:info.name];
            [self.cityAry addObject:info.city];
            [self.latAry addObject:[NSString stringWithFormat:@"%f",info.pt.latitude]];
            [self.lonAry addObject:[NSString stringWithFormat:@"%f",info.pt.longitude]];
            [self.addressAry addObject:info.address];
        }];
        if (self.addressAry.count == self.nameAry.count) {
            
        }else{
            int n = (int)self.nameAry.count - (int)self.addressAry.count;
            for (int i = 0; i < n; i++) {
                [self.addressAry addObject:@" "];
            }
        }
    }
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
}

-(void)dealloc{
    _mapView.delegate = nil;
    _location.delegate = nil;
    _searcher.delegate = nil;
}

@end
