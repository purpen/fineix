//
//  SceneLocationViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SceneLocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "MapAnnotionViewController.h"

#define MAPHEGHIT 150

@interface SceneLocationViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate>
/** 地图 */
@property (nonatomic, strong) BMKMapView *mapView;
/** 地图点击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *mapTap;
@end

@implementation SceneLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.mapView];
}

-(UITapGestureRecognizer *)mapTap{
    if (!_mapTap) {
        _mapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMap)];
    }
    return _mapTap;
}

-(void)tapMap{
    MapAnnotionViewController *vc = [[MapAnnotionViewController alloc] init];
    vc.firstName = self.locationNameMarr[0];
    vc.lat = [self.latitudeMarr[0] doubleValue];
    vc.lon = [self.longitudeMarr[0] doubleValue];
    [self.navigationController pushViewController:vc animated:YES];
}


-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-MAPHEGHIT, SCREEN_WIDTH, MAPHEGHIT)];
        _mapView.zoomLevel = 15;
        _mapView.delegate = self;
        [_mapView addGestureRecognizer:self.mapTap];
        //  添加渐变层
        CAGradientLayer * shadow = [CAGradientLayer layer];
        shadow.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
        shadow.opacity = 0.5;
        shadow.startPoint = CGPointMake(0, 1);
        shadow.endPoint = CGPointMake(0, 0);
        shadow.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
//        shadow.locations = @[@0.1,@0.4,@0.8,@1];
        [_mapView.layer addSublayer:shadow];
    }
    return _mapView;
}


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [super didUpdateBMKUserLocation:userLocation];
    _mapView.showsUserLocation = YES;
    [_mapView updateLocationData:userLocation];
    [_locationSearch stopUserLocationService];
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    [super onGetReverseGeoCodeResult:searcher result:result errorCode:error];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = [[self.latitudeMarr firstObject] doubleValue];
    coor.longitude = [[self.longitudeMarr firstObject] doubleValue];
    annotation.coordinate = coor;
    [self.mapView addAnnotation:annotation];
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        return newAnnotationView;
    }
    return nil;
}

-(void)dealloc{
    self.mapView.delegate = nil;
}

@end
