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
#import <SVProgressHUD/SVProgressHUD.h>
#import <UMSocialCore/UMSocialCore.h>
#import "ShareStyleTopView.h"
#import "ShareStyleViewOne.h"
#import "ShareStyleViewTwo.h"
#import "ShareStyleViewThree.h"

@interface FBShareViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) FBRequest           *shareTextNumRequest;
@property (nonatomic, strong) FBRequest           *sendExpRequest;
@property (nonatomic, strong) FBRequest           *sceneInfoRequest;
@property (nonatomic, strong) FBRequest           *shareRequest;
@property (nonatomic, strong) UIView              *topView;
@property (nonatomic, strong) UIButton            *closeBtn;
@property (nonatomic, strong) UIButton            *shareBtn;
@property (nonatomic, strong) UICollectionView    *styleView;
@property (nonatomic, strong) HomeSceneListRow    *sceneModel;
@property (nonatomic, strong) NSString            *sceneId;

@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) FBPopupView *sharePopView;
@property (nonatomic, strong) ShareStyleTopView *shareTopView;
@property (nonatomic, strong) ShareStyleViewOne *styleOneView;
@property (nonatomic, strong) ShareStyleViewTwo *styleTwoView;
@property (nonatomic, strong) ShareStyleViewThree *styleThreeView;

@end
