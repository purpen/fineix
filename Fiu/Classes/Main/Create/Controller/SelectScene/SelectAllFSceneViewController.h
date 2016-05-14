//
//  SelectAllFSceneViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface SelectAllFSceneViewController : FBPictureViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UIButton                *   sureBtn;                //  确定按钮
@pro_strong NSString                *   fiuSceneId;             //  所选情景id
@pro_strong NSString                *   fiuSceneTitle;          //  所选情景title

@pro_strong FBRequest               *   allSceneListRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;
@pro_strong UICollectionView        *   allSceneView;           //  全部的情景

@end