//
//  THNBankTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/3/10.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNYinHangModel.h"

#define THNBANKTableViewCell @"THNBankTableViewCell"

@interface THNBankTableViewCell : UITableViewCell

/**  */
@property (nonatomic, strong) THNYinHangModel *model;

@end
