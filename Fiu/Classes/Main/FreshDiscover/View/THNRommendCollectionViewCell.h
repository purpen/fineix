//
//  THNRecommendCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define THNRECOmmendCollectionViewCell @"THNREcommendCollectionViewCell"
@class StickModel;
@interface THNRommendCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) StickModel *model;
@end
