//
//  SearchLocationViewController.h
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "FBPictureViewController.h"
#import "FBSearchView.h"

typedef void(^SelectedLocationBlock)(NSString * location, NSString * city);

@interface SearchLocationViewController : FBPictureViewController <FBSearchDelegate, UITableViewDataSource, UITableViewDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
    BMKPoiSearch        *   _poiSearch;
    BMKLocationService  *   _locationSearch;
    BMKGeoCodeSearch    *   _geoCodeSearch;
    int                     num;
}

@pro_strong UIButton            *   positioningBtn;         //  定位按钮
@pro_strong UIButton            *   cancelVCBtn;            //  确定按钮
@pro_strong FBSearchView        *   searchView;             //  搜索框
@pro_strong UITableView         *   locationTableView;      //  地理位置列表

@pro_strong SelectedLocationBlock selectedLocationBlock;

@end
