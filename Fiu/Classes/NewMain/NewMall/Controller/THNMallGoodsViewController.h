//
//  THNMallGoodsViewController.h
//  Fiu
//
//  Created by FLYang on 2017/4/11.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNMallGoodsViewController : THNViewController <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

/**
 分类id
 */
@property (nonatomic, strong) NSString *categoryId;

/**
 获取分类商品列表

 @param idx 商品id
 */
- (void)thn_getCategoryGoodsListData:(NSString *)idx;

/**
 分类商品列表
 */
@property (nonatomic, strong) UICollectionView  *goodsList;
@property (nonatomic, strong) FBRequest *goodsListRequest;
@property (nonatomic, assign) NSInteger goodsCurrentpageNum;
@property (nonatomic, assign) NSInteger goodsTotalPageNum;
@property (nonatomic, strong) NSMutableArray *goodsListMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;
@property (nonatomic, strong) NSMutableArray *cageSubjectMarr;
@property (nonatomic, strong) NSMutableArray *cageSubjectIdMarr;
@property (nonatomic, strong) NSMutableArray *cageSubjectTypeMarr;

/**
 商品专题
 */
@property (nonatomic, strong) FBRequest *subjectRequest;

/**
 子视图的位置
 */
@property (nonatomic, assign) NSInteger index;

@end
