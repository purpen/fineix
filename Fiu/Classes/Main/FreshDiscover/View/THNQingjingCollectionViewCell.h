//
//  THNQingjingCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/24.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define THNQINGjingCollectionViewCell @"THNQingjingCollectionViewCell"

@interface THNQingjingCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *modelAry;
/**  */
@property (nonatomic, strong) UINavigationController *nav;

@end
