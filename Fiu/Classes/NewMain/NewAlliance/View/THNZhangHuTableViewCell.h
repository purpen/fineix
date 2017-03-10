//
//  THNZhangHuTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/3/8.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNZhangHuModel.h"

#define THNZHANGHuTableViewCell @"THNZhangHuTableViewCell"

@interface THNZhangHuTableViewCell : UITableViewCell

/**  */
@property (nonatomic, strong) UILabel *label;
/**  */
@property (nonatomic, strong) THNZhangHuModel *model;
/**  */
@property (nonatomic, strong) UIButton *circleBtn;

@end
