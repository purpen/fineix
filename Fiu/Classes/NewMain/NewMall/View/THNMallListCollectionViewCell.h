//
//  THNMallListCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNMallSubjectModelRow.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface THNMallListCollectionViewCell : UICollectionViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong UINavigationController *nav;
@pro_strong UIImageView *banner;
@pro_strong UILabel *title;
@pro_strong UILabel *suTitle;
@pro_strong UIButton *bannerBot;
@pro_strong UILabel *botLine;
@pro_strong UIView *bannerBg;
@pro_strong UICollectionView *goodsList;
@pro_strong NSMutableArray *goodsListMarr;
@pro_strong NSMutableArray *goodsIdMarr;

- (void)setMallSubjectData:(THNMallSubjectModelRow *)model;

@end
