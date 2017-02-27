//
//  THNCityCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/14.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityModel;

@interface THNCityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CityModel *model;
/**  */
@property (nonatomic, assign) BOOL selekt;
@property (nonatomic, strong) UILabel *name;
/**  */
@property (nonatomic, strong) UIImageView *bgImageView;

@end
