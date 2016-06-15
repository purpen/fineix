//
//  EditViewController.h
//  Fiu
//
//  Created by FLYang on 16/6/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "ScenceMessageView.h"
#import "EditSceneAddMoreView.h"
#import <SVProgressHUD/SVProgressHUD.h>

typedef void(^EditDone)();

@interface EditViewController : FBPictureViewController

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
@pro_strong ScenceMessageView       *   scenceView;             //  图片\描述\标题
@pro_strong EditSceneAddMoreView    *   addView;                //  添加地点\标签\场景
@pro_copy EditDone  editDone;

@end
