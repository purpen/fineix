//
//  ReleaseViewController.h
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "Fiu.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AddLocationView.h"
#import "AddContentView.h"
#import "FBPopupView.h"
#import "HomeSceneListRow.h"

@interface ReleaseViewController : FBPictureViewController

@pro_strong FBRequest           *   releaseSceneRequest;
@pro_strong FBRequest           *   releaseFiuSceneRequest;
@pro_strong FBRequest           *   getUserDesTagsRequest;
@pro_strong FBRequest           *   editSceneRequest;

@pro_strong NSMutableArray      *   goodsTitle;             //  商品标题
@pro_strong NSMutableArray      *   goodsId;                //  商品id
@pro_strong NSMutableArray      *   goodsX;                 //  商品坐标
@pro_strong NSMutableArray      *   goodsY;                 //  商品坐标
@pro_strong NSMutableArray      *   goodsLoc;               //  商品指向
@pro_strong NSMutableArray      *   goodsType;              //  商品类型
@pro_strong UIImage             *   bgImg;
@pro_strong AddLocationView     *   addLocaiton;
@pro_strong AddContentView      *   addContent;
@pro_strong FBPopupView         *   sharePopView;
/** 活动ID */
@pro_strong NSString *actionId;
/** 活动标题 */
@pro_strong NSString *activeTitle;

/**
 发布／编辑情境

 @param type    发布类型
 @param sceneId 情境id
 @param model   情境数据
 */
- (void)thn_releaseTheSceneType:(NSInteger)type withSceneId:(NSString *)sceneId withSceneData:(HomeSceneListRow *)model;

@end
