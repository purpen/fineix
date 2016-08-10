//
//  THNSceneInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "HomeSceneListRow.h"

@interface THNSceneInfoTableViewCell : UITableViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@pro_strong UIView *graybackView;
@pro_strong UILabel *content;
@pro_strong UIButton *moreIcon;
@pro_strong UICollectionView *tags;
@pro_assign CGFloat cellHigh;
@pro_assign CGFloat defaultCellHigh;

- (void)thn_setSceneContentData:(HomeSceneListRow *)contentModel;

@end
