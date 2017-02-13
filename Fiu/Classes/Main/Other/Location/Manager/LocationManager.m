//
//  LocationManager.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "LocationManager.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface LocationManager () <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

{
    float _la;
    float _lo;
    BMKReverseGeoCodeOption *_reverseGeoCodeSearchOption;//反向地理编码对象
}

@property (nonatomic, strong) BMKLocationService *locationSevice;
@property (nonatomic, strong) BMKGeoCodeSearch *codeSearch;//地理位置搜索对象（地理位置坐标编码）

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
        //创建定为服务对象
        self.locationSevice = [[BMKLocationService alloc] init];
        //设置定位服务对象代理
        self.locationSevice.delegate = self;
        self.locationSevice.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        //1，开启定位服务
        [self.locationSevice startUserLocationService];
    }
    return self;
}

#pragma mark -BMKLocationServiceDelegate
-(void)willStartLocatingUser{
}

-(void)didFailToLocateUserWithError:(NSError *)error{
    //[_hud hideAnimated:YES];
}

//定位成功，再次定位
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _la = userLocation.location.coordinate.latitude;
    _lo = userLocation.location.coordinate.longitude;
    
    [_locationSevice stopUserLocationService];
    
    //发起反向地理编码检索
    //创建地理位置搜索对象
    self.codeSearch = [[BMKGeoCodeSearch alloc] init];
    //设置地理位置搜索对象代理
    self.codeSearch.delegate = self;
    _reverseGeoCodeSearchOption = [[
                                    BMKReverseGeoCodeOption alloc]init];
    _reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [self.codeSearch reverseGeoCode:_reverseGeoCodeSearchOption];
    if(flag)
    {
    }
    else
    {
    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"%@", result);
    }
    else {
    }
}

@end
