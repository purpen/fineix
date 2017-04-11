//
//  THNMallBrandViewController.h
//  Fiu
//
//  Created by FLYang on 2017/4/11.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNMallBrandViewController : THNViewController <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *brandList;
@property (nonatomic, strong) FBRequest *brandRequest;
@property (nonatomic, strong) NSMutableArray *brandModelMarr;
@property (nonatomic, strong) NSMutableArray *brandIdMarr;

/**
 子视图的位置
 */
@property (nonatomic, assign) NSInteger index;

@end
