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

@property (nonatomic, strong) FBRequest           *   releaseSceneRequest;
@property (nonatomic, strong) FBRequest           *   releaseFiuSceneRequest;
@property (nonatomic, strong) FBRequest           *   getUserDesTagsRequest;
@property (nonatomic, strong) FBRequest           *   editSceneRequest;

@property (nonatomic, strong) NSMutableArray      *   goodsTitle;             //  商品标题
@property (nonatomic, strong) NSMutableArray      *   goodsId;                //  商品id
@property (nonatomic, strong) NSMutableArray      *   goodsX;                 //  商品坐标
@property (nonatomic, strong) NSMutableArray      *   goodsY;                 //  商品坐标
@property (nonatomic, strong) NSMutableArray      *   goodsLoc;               //  商品指向
@property (nonatomic, strong) NSMutableArray      *   goodsType;              //  商品类型
@property (nonatomic, strong) UIImage             *   bgImg;
@property (nonatomic, strong) AddLocationView     *   addLocaiton;
@property (nonatomic, strong) AddContentView      *   addContent;
@property (nonatomic, strong) FBPopupView         *   sharePopView;
/** 活动ID */
@property (nonatomic, strong) NSString *actionId;
/** 活动标题 */
@property (nonatomic, strong) NSString *activeTitle;
/**
 所属地盘id
 */
@property (nonatomic, strong) NSString *domainId;

/**
 发布／编辑情境

 @param type    发布类型
 @param sceneId 情境id
 @param model   情境数据
 */
- (void)thn_releaseTheSceneType:(NSInteger)type withSceneId:(NSString *)sceneId withSceneData:(HomeSceneListRow *)model;

@end
