//
//  THNDomainMenuCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "DomainCategoryRow.h"

@interface THNDomainMenuCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *title;

- (void)setDomainMenuDataModel:(DomainCategoryRow *)model;

@end
