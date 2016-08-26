//
//  MallMenuCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CategoryRow.h"
#import "UIImageView+SDWedImage.h"

@interface MallMenuCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView         *   menuImg;    //  导航图
@pro_strong UILabel             *   menuTitle;  //  导航标题
@pro_strong UILabel             *   botLine;

/**
 * type
 * 0:情境分类 ／ 1:好货分类
 */
- (void)setCategoryData:(CategoryRow *)model type:(NSInteger)type;

@end
