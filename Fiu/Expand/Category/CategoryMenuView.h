//
//  CategoryMenuView.h
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CategoryRow.h"

@interface CategoryMenuView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UINavigationController      *   nav;
@pro_strong UICollectionView            *   categoryMenu;
@pro_strong NSMutableArray              *   categoryIdMarr;     //  分类ID
@pro_strong NSMutableArray              *   categoryTitleMarr;  //  分类标题
@pro_strong NSMutableArray              *   rowMarr;            //  分类model

/**
 *  type
 *  1:发现 ／ 2:好货
 */
- (void)setCategoryData:(NSMutableArray *)category withType:(NSInteger)type;

@end
