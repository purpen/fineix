//
//  FBShareViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "Fiu.h"
#import "ShareViewController.h"
#import "FBPopupView.h"
#import "HomeSceneListRow.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "ShareStyleTopView.h"
#import "ShareStyleViewOne.h"
#import "ShareStyleViewTwo.h"
#import "ShareStyleViewThree.h"

@interface FBShareViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UMSocialUIDelegate>

@pro_strong FBRequest           *   shareTextNumRequest;
@pro_strong FBRequest           *   sendExpRequest;
@pro_strong FBRequest           *   sceneInfoRequest;
@pro_strong UIView              *   topView;
@pro_strong UIButton            *   closeBtn;
@pro_strong UIButton            *   shareBtn;
@pro_strong UICollectionView    *   styleView;
@pro_strong HomeSceneListRow    *   sceneModel;
@pro_strong NSString            *   sceneId;

@pro_strong UIView *shareView;
@pro_strong FBPopupView *sharePopView;
@pro_strong ShareStyleTopView *shareTopView;
@pro_strong ShareStyleViewOne *styleOneView;
@pro_strong ShareStyleViewTwo *styleTwoView;
@pro_strong ShareStyleViewThree *styleThreeView;

@end
