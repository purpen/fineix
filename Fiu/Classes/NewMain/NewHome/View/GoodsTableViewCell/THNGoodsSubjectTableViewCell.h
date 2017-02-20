//
//  THNGoodsSubjectTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNMallSubjectModelRow.h"

@interface THNGoodsSubjectTableViewCell : UITableViewCell <
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

- (void)thn_setGoodsSubjectData:(NSMutableArray *)data;

@end
