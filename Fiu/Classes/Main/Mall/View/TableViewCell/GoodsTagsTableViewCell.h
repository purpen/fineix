//
//  GoodsTagsTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/6/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"


@interface GoodsTagsTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@pro_strong UINavigationController      *   nav;
@pro_strong UICollectionView            *   chooseTagView;  //  选择的标签列表
@pro_strong NSMutableArray              *   chooseTagMarr;

- (void)setGoodsTagsTitleData:(NSArray *)model;

@end
