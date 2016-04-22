//
//  InfoBrandTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface InfoBrandTableViewCell : UITableViewCell

@pro_strong UIImageView             *   brandImg;       //  品牌Logo
@pro_strong UILabel                 *   brandTitle;     //  品牌名称
@pro_strong UIImageView             *   nextIcon;       //  指示图标

- (void)setUI;

@end
