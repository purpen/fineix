//
//  LocationManager.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager () <CLLocationManagerDelegate>

/**  */
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationManager

+ (LocationManager *)shareLocation
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

- (void)findMe
{
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    __block NSString *city;
    [clGeoCoder reverseGeocodeLocation:location completionHandler: ^(NSArray *placemarks,NSError *error) {
        CLPlacemark *placeMark = placemarks[0];
        NSDictionary *addressDic=placeMark.addressDictionary;
        city=[addressDic objectForKey:@"City"];
        if ([self.locationDelegate respondsToSelector:@selector(setLocalCityStr:)]) {
            [self.locationDelegate setLocalCityStr:city];
        }
        // 2.停止定位
        [manager stopUpdatingLocation];
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

@end
