//
//  HomeThemeTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface HomeThemeTableViewCell : UITableViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@pro_strong UINavigationController *nav;
@pro_strong UICollectionView *themeCollectionView;
@pro_strong NSMutableArray *themeMarr;
@pro_strong NSMutableArray *themeIdMarr;
@pro_strong NSMutableArray *themeTypeMarr;

- (void)setThemeModelArr:(NSMutableArray *)data;

@end
