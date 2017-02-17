//
//  THNSortCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define THNSORTCollectionViewCell @"THNSortCollectionViewCell"
@class Pro_categoryModel;
@class UsersModel;
@interface THNSortCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) Pro_categoryModel *model;
/**  */
@property (nonatomic, strong) UsersModel *userModel;
@end
