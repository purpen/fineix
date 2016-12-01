//
//  FBOrderOtherTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface FBOrderOtherTableViewCell : UITableViewCell

@pro_strong UILabel         *   titleLab;
@pro_strong UILabel         *   textLab;
@pro_strong UIImageView     *   seletedIcon;

- (void)thn_setFreightMoney:(NSString *)price;

@end
