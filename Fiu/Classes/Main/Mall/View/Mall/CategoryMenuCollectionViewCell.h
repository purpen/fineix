//
//  CategoryMenuCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CategoryRow.h"
#import "UIImageView+SDWedImage.h"

@interface CategoryMenuCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView     *   categoryImg;
@pro_strong UILabel         *   categoryLab;

- (void)setCategoryData:(CategoryRow *)model;

@end
