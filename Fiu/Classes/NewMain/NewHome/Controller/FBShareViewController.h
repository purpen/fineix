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
#import "ShareStyleTopView.h"
#import "FBPopupView.h"
#import "HomeSceneListRow.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface FBShareViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UMSocialUIDelegate>

@pro_strong FBRequest           *   shareTextNumRequest;
@pro_strong FBRequest           *   sendExpRequest;
@pro_strong UIView              *   topView;
@pro_strong UIButton            *   closeBtn;
@pro_strong UIButton            *   shareBtn;
@pro_strong UICollectionView    *   styleView;
@pro_strong HomeSceneListRow    *   sceneModel;
@pro_strong NSString            *   sceneId;

@pro_strong UIView                      *   shareView;
@pro_strong ShareStyleTopView           *   shareTopView;
@pro_strong FBPopupView                 *   sharePopView;

@end
