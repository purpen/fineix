//
//  SearchLocationViewController.h
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBSearchView.h"

@interface SearchLocationViewController : FBPictureViewController <FBSearchDelegate>

@pro_strong UIButton            *   positioningBtn;         //  定位按钮
@pro_strong UIButton            *   cancelVCBtn;            //  确定按钮
@pro_strong FBSearchView        *   searchView;             //  搜索框

@end
