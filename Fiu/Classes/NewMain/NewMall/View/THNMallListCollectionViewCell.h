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

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UIImageView *banner;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *suTitle;
@property (nonatomic, strong) UIButton *bannerBot;
@property (nonatomic, strong) UILabel *botLine;
@property (nonatomic, strong) UIView *bannerBg;
@property (nonatomic, strong) UICollectionView *goodsList;
@property (nonatomic, strong) NSMutableArray *goodsListMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;

- (void)setMallSubjectData:(THNMallSubjectModelRow *)model;

- (void)thn_hiddenCellView;

@end
