//
//  ChooseCategoryCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CatagoryFiuSceneModel.h"

@interface ChooseCategoryCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView     *   categoryImg;
@pro_strong UILabel         *   categoryTitle;

- (void)setCategoryData:(CatagoryFiuSceneModel *)model;

@end
