//
//  ReleaseViewController.h
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "Fiu.h"
#import "ScenceMessageView.h"
#import "ScenceAddMoreView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ReleaseViewController : FBPictureViewController

@pro_strong FBRequest           *   releaseSceneRequest;

@pro_strong NSString            *   lat;            //  经度
@pro_strong NSString            *   lng;            //  纬度
@pro_strong NSArray             *   locationArr;    //  照片位置
@pro_strong ScenceMessageView   *   scenceView;     //  图片\描述\标题
@pro_strong ScenceAddMoreView   *   addView;        //  添加地点\标签\场景

@end
