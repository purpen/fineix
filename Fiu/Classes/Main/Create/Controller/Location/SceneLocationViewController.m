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
@end

@implementation SceneLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.mapView];
    [self.locService startUserLocationService];
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
}

@end
