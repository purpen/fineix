//
//  THNRemindTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNRemindModelRow.h"

@interface THNRemindTableViewCell : UITableViewCell

@pro_strong UINavigationController *nav;
@pro_strong UIImageView *headerImg;
@pro_strong UILabel *content;
@pro_strong UILabel *time;
@pro_strong UIImageView *sceneImg;
@pro_strong UILabel *tips;

- (void)thn_setRemindData:(THNRemindModelRow *)model;

@end
