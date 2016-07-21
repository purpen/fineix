//
//  ChooseCategotyViewController.h
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"

typedef void(^GetCategoryData)(NSString * title, NSString * categroyId);

@interface ChooseCategotyViewController : FBPictureViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong FBRequest           *   categoryListRequest;
@pro_strong UICollectionView    *   categoryView;
@pro_copy GetCategoryData           getCategoryData;

@end
