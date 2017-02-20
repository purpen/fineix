//
//  THNBusinessTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "DominInfoData.h"

@interface THNBusinessTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *persoMoney;

- (void)thn_setBusinessData:(DominInfoData *)model;

@end
