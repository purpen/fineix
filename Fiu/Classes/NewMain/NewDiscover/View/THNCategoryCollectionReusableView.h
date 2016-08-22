//
//  THNCategoryCollectionReusableView.h
//  Fiu
//
//  Created by FLYang on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "FBCategoryView.h"
#import "CategoryRow.h"
#import "GroupHeaderView.h"

@interface THNCategoryCollectionReusableView : UICollectionReusableView <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UINavigationController *nav;
@pro_strong UICollectionView *menuView;         //  菜单列表
@pro_strong NSMutableArray *titleMarr;          //  标题
@pro_strong NSMutableArray *categoryIdMarr;     //  获取子分类ID
@pro_strong NSMutableArray *rowMarr;            //  分类model
@pro_strong NSMutableArray *idMarr;             //  分类id
@pro_strong NSMutableArray *categoryMarr;
@pro_strong NSMutableArray *categoryTitleMarr;
@pro_strong GroupHeaderView *headerView;

/**
 *  type
 *  0:发现页   1:商品页
 */
- (void)setCategoryData:(NSMutableArray *)category type:(NSInteger)type;

@end
