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

@protocol SearDelaget <NSObject>

-(void)searchLocationWithName:(NSString *)name andCity:(NSString *)city andLat:(NSString*)lat andLon:(NSString*)lon;

@end

typedef void(^SelectedLocationBlock)(NSString *location, NSString *city, NSString *latitude, NSString *longitude);

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


/**
 返回类型／pop／diss
 */
@property (nonatomic, strong) NSString            *   type;
@property (nonatomic, strong) UIButton            *   positioningBtn;         //  定位按钮
@property (nonatomic, strong) UIButton            *   cancelVCBtn;            //  确定按钮
@property (nonatomic, strong) FBSearchView        *   searchView;             //  搜索框
@property (nonatomic, strong) UITableView         *   locationTableView;      //  地理位置列表
@property (nonatomic, strong) NSMutableArray      *   locationNameMarr;       //  搜索结果
@property (nonatomic, strong) NSMutableArray      *   locationCityMarr;       //  搜索城市
@property (nonatomic, strong) NSMutableArray      *   locationAddressMarr;    //  搜索地址
@property (nonatomic, strong) NSMutableArray      *   latitudeMarr;           //  纬度
@property (nonatomic, strong) NSMutableArray      *   longitudeMarr;          //  纬度

/**  */
@property (nonatomic, weak) id<SearDelaget> delegeta;

@property (nonatomic, strong) SelectedLocationBlock selectedLocationBlock;

@end
