//
//  THNBusinessInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNBusinessInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

- (void)thn_setBusinessInfoData:(NSString *)left right:(NSString *)right;

@end
