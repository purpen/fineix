//
//  SelectHotFSceneTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface SelectHotFSceneTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UICollectionView        *   allSceneView;           //  全部的情景
@pro_strong NSMutableArray          *   dataMarr;               //  情景数据
@pro_assign CGFloat                     cellHeight;

- (void)getCellHeiht:(NSMutableArray *)marr;

- (void)setSelectHotFSceneData:(NSMutableArray *)data;

@end
