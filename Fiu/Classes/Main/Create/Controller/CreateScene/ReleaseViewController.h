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
#import "ShowContentView.h"
#import "AddTagsView.h"

@interface ReleaseViewController : FBPictureViewController <ShowContentViewDelegate, AddTagsViewDelegate>

@pro_strong FBRequest           *   releaseSceneRequest;
@pro_strong FBRequest           *   releaseFiuSceneRequest;
@pro_strong FBRequest           *   getUserDesTagsRequest;

@pro_strong NSMutableArray      *   goodsTitle;             //  商品标题
@pro_strong NSMutableArray      *   goodsId;                //  商品id
@pro_strong NSMutableArray      *   goodsX;                 //  商品坐标
@pro_strong NSMutableArray      *   goodsY;                 //  商品坐标
@pro_strong NSMutableArray      *   goodsLoc;               //  商品指向
@pro_strong UIImage             *   bgImg;
@pro_strong AddLocationView     *   addLocaiton;
@pro_strong AddContentView      *   addContent;

@end
