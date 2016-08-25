//
//  ThemeTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModelRow.h"
#import "THNMacro.h"

@interface ThemeTableViewCell : UITableViewCell

@pro_strong UIImageView *banner;
@pro_strong UILabel *title;
@pro_strong UILabel *suTitle;
@pro_strong UILabel *botLine;
@pro_strong UIView *bannerBg;

- (void)setthemeListData:(ThemeModelRow *)model;

@end
