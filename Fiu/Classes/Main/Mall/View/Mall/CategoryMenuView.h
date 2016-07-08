//
//  CategoryMenuView.h
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface CategoryMenuView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UINavigationController      *   nav;
@pro_strong UICollectionView            *   categoryMenu;
@pro_strong NSMutableArray              *   titleMarr;          //  标题
@pro_strong NSMutableArray              *   categoryIdMarr;     //  获取子分类ID
@pro_strong NSMutableArray              *   rowMarr;            //  分类model
@pro_strong NSMutableArray              *   idMarr;             //  分类id

- (void)setCategoryData:(NSMutableArray *)category;

@end
