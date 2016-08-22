//
//  THNMallListCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNMallListCollectionViewCell : UICollectionViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong UIImageView *banner;
@pro_strong UILabel *title;
@pro_strong UILabel *suTitle;
@pro_strong UIButton *lookAll;
@pro_strong UIButton *bannerBot;
@pro_strong UICollectionView *goodsList;

@end
