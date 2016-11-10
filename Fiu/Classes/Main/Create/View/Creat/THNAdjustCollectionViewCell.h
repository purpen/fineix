//
//  THNAdjustCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/11/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNAdjustCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView *adjustImage;
@pro_strong UILabel *adjustTitle;

/**
 设置功能图标

 @param image 图标
 */
- (void)thn_getAdjustIconImage:(NSString *)image;


/**
 设置功能名称

 @param title 名称
 */
- (void)thn_getAdjustTitle:(NSString *)title;

@end
