//
//  MallMenuTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CategoryRow.h"

@interface MallMenuTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UINavigationController      *   nav;
@pro_strong UICollectionView            *   menuView;           //  菜单列表
@pro_strong NSMutableArray              *   titleMarr;          //  标题
@pro_strong NSMutableArray              *   categoryIdMarr;     //  获取子分类ID
@pro_strong NSMutableArray              *   rowMarr;            //  分类model
@pro_strong NSMutableArray              *   idMarr;             //  分类id

- (void)setCategoryData:(NSMutableArray *)category;

@end
