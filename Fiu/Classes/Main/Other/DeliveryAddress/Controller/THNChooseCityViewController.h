//
//  THNChooseCityViewController.h
//  Fiu
//
//  Created by FLYang on 2016/10/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"


/**
 获取选择的地址id

 @param provinceId 省份id 1级
 @param cityId     城市id 2级
 @param countyId   地区id 3级
 @param streetId   街道id 4级
 */
typedef void(^GetChooseAddressId)(NSString *provinceId, NSString *cityId, NSString *countyId, NSString *streetId);


/**
 获取选择的地址名称

 @param provinceName 省份
 @param cityName     城市
 @param countyName   地区
 @param streetName   街道
 */
typedef void(^GetChooseAddressName)(NSString *provinceName, NSString *cityName, NSString *countyName, NSString *streetName);

@interface THNChooseCityViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    UIScrollViewDelegate
>

/**
 省份
 */
@pro_strong FBRequest *provinceRequest;
@pro_strong UITableView *chooseCityTable;
@pro_strong NSMutableArray *provinceMarr;
@pro_strong NSMutableArray *provinceIdMarr;

/**
 城市
 */
@pro_strong FBRequest *cityRequest;
@pro_strong NSMutableArray *cityMarr;
@pro_strong NSMutableArray *cityIdMarr;

/**
 地区
 */
@pro_strong FBRequest *countyRequest;
@pro_strong NSMutableArray *countyMarr;
@pro_strong NSMutableArray *countyIdMarr;

/**
 街道
 */
@pro_strong FBRequest *streetRequest;
@pro_strong NSMutableArray *streetMarr;
@pro_strong NSMutableArray *streetIdMarr;

/**
 选择地址提示视图
 */
@pro_strong UIView *promptView;
@pro_strong UIButton *backButton;
@pro_strong UILabel *textLable;

/**
 获取选择的地址id
 */
@pro_copy GetChooseAddressId getChooseAddressId;
@pro_strong NSMutableArray *addressIdMarr;

/**
 获取选择的地址名称
 */
@pro_copy GetChooseAddressName getChooseAddressName;
@pro_strong NSMutableArray *addressNameMarr;

@end
