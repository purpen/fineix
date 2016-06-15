//
//  SearchLocationViewController.h
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "FBPictureViewController.h"
#import "FBSearchView.h"

typedef void(^SelectedLocationBlock)(NSString * location, NSString * city, NSString * latitude, NSString * longitude);

@interface SearchLocationViewController : FBPictureViewController <
    FBSearchDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    BMKPoiSearchDelegate,
    BMKLocationServiceDelegate,
    BMKGeoCodeSearchDelegate
>
{
    BMKPoiSearch        *   _poiSearch;
    BMKLocationService  *   _locationSearch;
    BMKGeoCodeSearch    *   _geoCodeSearch;
    CGFloat                 latitude;       //  纬度
    CGFloat                 longitude;      //  经度
}

@pro_strong NSString            *   type;
@pro_strong UIButton            *   positioningBtn;         //  定位按钮
@pro_strong UIButton            *   cancelVCBtn;            //  确定按钮
@pro_strong FBSearchView        *   searchView;             //  搜索框
@pro_strong UITableView         *   locationTableView;      //  地理位置列表
@pro_strong NSMutableArray      *   locationNameMarr;       //  搜索结果
@pro_strong NSMutableArray      *   locationCityMarr;       //  搜索城市
@pro_strong NSMutableArray      *   locationAddressMarr;    //  搜索地址
@pro_strong NSMutableArray      *   latitudeMarr;           //  纬度
@pro_strong NSMutableArray      *   longitudeMarr;          //  纬度


@pro_strong SelectedLocationBlock selectedLocationBlock;

@end
