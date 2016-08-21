//
//  THNDiscoverSceneTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "HomeSceneListRow.h"

@interface THNDiscoverSceneTableViewCell : UITableViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong UICollectionView *sceneList;

- (void)thn_setSceneUserInfoData:(HomeSceneListRow *)userModel;

@end
