//
//  HomeThemeCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "UIImageView+SDWedImage.h"
#import "FBSubjectModelRow.h"

@interface HomeThemeCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView *image;
@pro_strong UILabel *title;
@pro_strong UIImageView *typeImage;
@pro_strong UIButton *peopleNum;
@pro_strong UILabel *more;

- (void)setMoreTheme;

- (void)setThemeDataModel:(FBSubjectModelRow *)model;

@end
