//
//  THNMabeLikeTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define THNMABLELikeTableViewCell @"THNMabeLikeTableViewCell"

@interface THNMabeLikeTableViewCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;
/**  */
@property (nonatomic, strong) NSArray *modelAry;
/**  */
@property (nonatomic, strong) UINavigationController *nav;
/**  */
@property(nonatomic,copy) NSString *string;

@end

#define THNMABLELikeTableViewCellcell @"THNMabeLikeTableViewCellcell"

@class THNProductDongModel;

@interface THNMabeLikeTableViewCellcell : UICollectionViewCell

@property (nonatomic, strong) THNProductDongModel *model;
/**  */
@property (nonatomic, strong) UIView *lineView;

@end
