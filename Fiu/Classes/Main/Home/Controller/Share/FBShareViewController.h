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
#import "ShareStyleBottomView.h"
#import "ShareStyleTitleBottomView.h"
#import "ShareStyleTitleTopView.h"

@interface FBShareViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UIView              *   topView;
@pro_strong UIButton            *   closeBtn;
@pro_strong UIButton            *   shareBtn;
@pro_strong UICollectionView    *   styleView;
@pro_strong NSDictionary        *   dataDict;

@pro_strong UIView                      *   shareView;
@pro_strong ShareStyleTopView           *   shareTopView;
@pro_strong ShareStyleBottomView        *   shareBottomView;
@pro_strong ShareStyleTitleBottomView   *   shareTitleBottomView;
@pro_strong ShareStyleTitleTopView      *   shareTitleTopView;

@end
