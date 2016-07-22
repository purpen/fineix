//
//  EditViewController.h
//  Fiu
//
//  Created by FLYang on 16/6/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AddLocationView.h"
#import "AddCategoryView.h"
#import "AddContentView.h"
#import "ShowContentView.h"
#import "AddTagsView.h"

typedef void(^EditSceneDone)();

@interface EditViewController : FBPictureViewController <ShowContentViewDelegate, AddTagsViewDelegate>

@pro_strong FBRequest               *   editSceneRequest;
@pro_strong FBRequest               *   editFiuSceneRequest;
@pro_strong NSDictionary            *   data;
@pro_strong NSString                *   ids;
@pro_strong NSString                *   createType;             //  编辑类型（场景/情景）
@pro_strong NSString                *   tagS;                   //  标签
@pro_strong NSString                *   fSceneId;               //  情景id
@pro_strong NSString                *   fSceneTitle;
@pro_strong NSString                *   lat;                    //  经度
@pro_strong NSString                *   lng;                    //  纬度

/*-- --*/
@pro_strong UIImageView         *   bgImgView;
@pro_strong UIImage             *   bgImg;
@pro_strong UIView              *   topView;
@pro_strong AddLocationView     *   addLocaiton;
@pro_strong AddCategoryView     *   addCategory;
@pro_strong AddContentView      *   addContent;
@pro_strong ShowContentView     *   showContent;
@pro_strong AddTagsView         *   addTagsView;
@pro_strong UIButton            *   addContentBtn;

@pro_copy EditSceneDone  editSceneDone;

@end
