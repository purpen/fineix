//
//  SubscribeViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@interface SubscribeViewController : FBViewController


@pro_strong FBRequest               *   allSceneListRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;
@pro_strong UICollectionView        *   allSceneView;       //  全部的情景

@end
