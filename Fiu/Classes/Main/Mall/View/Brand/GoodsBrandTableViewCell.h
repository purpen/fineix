//
//  GoodsBrandTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "UILable+Frame.h"
#import "UIImageView+SDWedImage.h"
#import "BrandInfoData.h"

@interface GoodsBrandTableViewCell : UITableViewCell

@pro_strong UIImageView         *   brandBgImg;         //   品牌的背景
@pro_strong UIImageView         *   brandImg;           //   品牌的头像
@pro_strong UILabel             *   brandIntroduce;     //   品牌介绍
@pro_assign CGFloat                 cellHeight;

- (void)setBrandInfoData:(BrandInfoData *)model;

- (void)getContentCellHeight:(NSString *)content;

@end
