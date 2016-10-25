//
//  THNChooseCityViewController.h
//  Fiu
//
//  Created by FLYang on 2016/10/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

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

@end
