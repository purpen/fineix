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
    UICollectionViewDataSource
>

@pro_strong UICollectionView *themeCollectionView;

@end
