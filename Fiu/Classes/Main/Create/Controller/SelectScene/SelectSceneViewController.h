//
//  SelectSceneViewController.h
//  fineix
//
//  Created by FLYang on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^GetSeletFSceneIdAndTitlelBlock)(NSString * idx, NSString * title);

@interface SelectSceneViewController : FBPictureViewController <UITableViewDelegate, UITableViewDataSource, BMKLocationServiceDelegate>
{
    BMKLocationService  *   _locationSearch;
    CGFloat                 latitude;       //  纬度
    CGFloat                 longitude;      //  经度
}

@pro_strong UITableView         *   selectTable;
@pro_strong UIButton            *   beginSearchBtn;     //  搜索情境
@pro_strong UIButton            *   sureBtn;            //  确定按钮
@pro_strong UILabel             *   cellLine;
@pro_strong FBRequest           *   fSceneRequest;      //  赴京的情景
@pro_strong FBRequest           *   hotFSceneRequest;   //  推荐的情景
@pro_strong NSString            *   fSceneId;           //  选中的id
@pro_strong NSString            *   fSceneTitle;        //  选中的标题

@pro_strong GetSeletFSceneIdAndTitlelBlock  getIdxAndTitltBlock;

@end
