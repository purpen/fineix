//
//  THNHomeSubjectTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "HomeSubjectRow.h"

@interface THNHomeSubjectTableViewCell : UITableViewCell

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UIImageView *bannerImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *suTitle;
@property (nonatomic, strong) UILabel *botLine;
@property (nonatomic, strong) UIView *bannerBg;
@property (nonatomic, strong) UIImageView *typeImage;

- (void)thn_setSubjectModel:(HomeSubjectRow *)model;

@end
