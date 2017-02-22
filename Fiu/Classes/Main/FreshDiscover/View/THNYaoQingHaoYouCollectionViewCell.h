//
//  THNYaoQingHaoYouCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/21.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define THNYAOQingHaoYouCollectionViewCell @"THNYaoQingHaoYouCollectionViewCell"
@class Pro_categoryModel;
@class UsersModel;
@interface THNYaoQingHaoYouCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) Pro_categoryModel *model;
/**  */
@property (nonatomic, strong) UsersModel *userModel;
/**  */
@property (nonatomic, strong) Pro_categoryModel *pModel;
@end
