//
//  THNSearchBrandTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "FiuBrandRow.h"

@interface THNSearchBrandTableViewCell : UITableViewCell

@pro_strong UIImageView *image;
@pro_strong UILabel *name;
@pro_strong UIButton *icon;

- (void)setBrandDataWithTitle:(NSString *)title withImage:(NSString *)image;

@end
