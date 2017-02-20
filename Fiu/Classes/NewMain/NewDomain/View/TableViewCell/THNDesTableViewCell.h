//
//  THNDesTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "DominInfoData.h"

@interface THNDesTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, assign) CGFloat cellHigh;
@property (nonatomic, assign) CGFloat defaultCellHigh;

- (void)thn_setDesData:(DominInfoData *)model;

@end
