//
//  SeleBrandViewController.h
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@interface SeleBrandViewController : FBViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UICollectionView        *   selfBrandList;
@pro_strong FBRequest               *   selfBrandListRequest;
@pro_strong NSMutableArray          *   selfBrandListMarr;
@pro_strong NSMutableArray          *   selfBrandIdMarr;

@end
