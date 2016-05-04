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
@pro_strong FBRequest           *   releaseFiuSceneRequest;
@pro_strong NSString            *   createType;             //  创建类型（场景/情景）

@pro_strong NSString            *   goodsTitle;             //  商品标题
@pro_strong NSString            *   goodsId;                //  商品id
@pro_strong NSString            *   goodsPrice;             //  商品价格
@pro_strong NSString            *   goodsX;                 //  商品坐标
@pro_strong NSString            *   goodsY;                 //  商品坐标
@pro_strong NSString            *   tagS;                   //  标签
@pro_strong NSString            *   fSceneId;               //  情景id
@pro_strong NSString            *   lat;                    //  经度
@pro_strong NSString            *   lng;                    //  纬度
@pro_strong NSArray             *   locationArr;            //  照片位置
@pro_strong ScenceMessageView   *   scenceView;             //  图片\描述\标题
@pro_strong ScenceAddMoreView   *   addView;                //  添加地点\标签\场景

@end
