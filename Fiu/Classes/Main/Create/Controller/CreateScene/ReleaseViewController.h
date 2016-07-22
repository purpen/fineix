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
#import "AddCategoryView.h"
#import "AddContentView.h"

@interface ReleaseViewController : FBPictureViewController <AddContentViewDelegate>

@pro_strong FBRequest           *   releaseSceneRequest;
@pro_strong FBRequest           *   releaseFiuSceneRequest;
@pro_strong FBRequest           *   getUserDesTagsRequest;

@pro_strong NSString            *   createType;             //  创建类型（场景/情景）
@pro_strong NSArray             *   goodsTitle;             //  商品标题
@pro_strong NSArray             *   goodsId;                //  商品id
@pro_strong NSArray             *   goodsPrice;             //  商品价格
@pro_strong NSArray             *   goodsX;                 //  商品坐标
@pro_strong NSArray             *   goodsY;                 //  商品坐标
@pro_strong NSString            *   fSceneId;
@pro_strong NSString            *   fSceneTitle;

/*-- --*/
@pro_strong UIImageView         *   bgImgView;
@pro_strong UIImage             *   bgImg;
@pro_strong UIView              *   topView;
@pro_strong AddLocationView     *   addLocaiton;
@pro_strong AddCategoryView     *   addCategory;
@pro_strong AddContentView      *   addContent;
@pro_strong UIButton            *   addContentBtn;

@end
