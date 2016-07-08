//
//  SceneLocationViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SceneLocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#define MAPHEGHIT 150

@interface SceneLocationViewController ()<BMKLocationServiceDelegate>
/** 地图 */
@property (nonatomic, strong) BMKMapView *mapView;
/** 定位服务 */
@property (nonatomic, strong) BMKLocationService *locService;
/** 地图点击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *mapTap;
@end

@implementation SceneLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.mapView];
    [self.locService startUserLocationService];
}

-(UITapGestureRecognizer *)mapTap{
    if (!<#成员属性#>) {
        <#成员属性#> = <#创建成员属性#>;
    }
    return <#成员属性#>;
}

-(BMKLocationService *)locService{
    if (!_locService) {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    }
    return _locService;
}

-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-MAPHEGHIT, SCREEN_WIDTH, MAPHEGHIT)];
        _mapView.zoomLevel = 15;
    }
    return _mapView;
}

-(UITableView *)locationTableView{
    UITableView *tableview = [super locationTableView];
    tableview.frame = CGRectMake(0, 94, SCREEN_WIDTH, SCREEN_HEIGHT-MAPHEGHIT);
    return tableview;
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _mapView.showsUserLocation = YES;
    [_mapView updateLocationData:userLocation];
    [_locationSearch stopUserLocationService];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    

    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = [self.latitudeMarr[0] doubleValue];
    coor.longitude = [self.longitudeMarr[0] doubleValue];
    annotation.coordinate = coor;
    [self.mapView addAnnotation:annotation];
}

@end
