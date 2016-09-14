//
//  FBAlertViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HomeSceneListRow.h"

typedef void(^OpenCommentVC)();
typedef void(^DeleteScene)(NSString *sceneId);
typedef void(^EditDoneAndRefresh)();
typedef void(^SureFavoriteTheScene)(NSString *sceneId);
typedef void(^SureCancelFavoriteTheScene)(NSString *sceneId);

@interface FBAlertViewController : UIViewController

@pro_strong NSString            *   type;
@pro_strong UIButton            *   closeBtn;
@pro_strong NSString            *   targetId;
@pro_strong UIView              *   alertView;
@pro_strong HomeSceneListRow    *   sceneModel;
@pro_copy OpenCommentVC         openCommentVc;
@pro_copy DeleteScene           deleteScene;
@pro_copy EditDoneAndRefresh    editDoneAndRefresh;
@pro_copy SureFavoriteTheScene  favoriteTheScene;
@pro_copy SureCancelFavoriteTheScene  cancelFavoriteTheScene;

- (void)initFBAlertVcStyle:(BOOL)isUserSelf isFavorite:(NSInteger)favorite;

@end
