//
//  THNNiceGoodsViewController.h
//  Fiu
//
//  Created by FLYang on 2017/2/24.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNNiceGoodsViewController : THNViewController <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) FBRequest *subjectRequest;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;
@property (nonatomic, strong) UICollectionView *mallList;
@property (nonatomic, strong) NSMutableArray *subjectMarr;
@property (nonatomic, strong) NSMutableArray *subjectIdMarr;
@property (nonatomic, strong) NSMutableArray *subjectTypeMarr;

/**
 是否作为子视图
 */
@property (nonatomic, assign) NSInteger isIndex;

@end
