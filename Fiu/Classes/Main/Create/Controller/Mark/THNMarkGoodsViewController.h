//
//  THNMarkGoodsViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBSearchView.h"
#import "FBMenuView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface THNMarkGoodsViewController : FBPictureViewController <
    FBSearchDelegate,
    FBMenuViewDelegate
>

@pro_strong FBSearchView *searchGoods;  //  搜索框

@end
