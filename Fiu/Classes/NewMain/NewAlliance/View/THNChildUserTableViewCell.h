//
//  THNChildUserTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNChildUserModel.h"

@interface THNChildUserTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel       *lineLabel;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UILabel       *moneyLabel;
@property (nonatomic, strong) UIImageView   *iconImage;

- (void)thn_setChildUserData:(THNChildUserModel *)model;

@end
