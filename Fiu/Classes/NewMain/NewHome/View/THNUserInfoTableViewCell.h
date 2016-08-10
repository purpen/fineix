//
//  THNUserInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "THNMacro.h"
#import "HomeSceneListRow.h"

@interface THNUserInfoTableViewCell : UITableViewCell

@pro_strong UIButton *head;
@pro_strong UILabel *name;
@pro_strong UIButton *time;
@pro_strong UIButton *address;
@pro_strong UIButton *follow;

- (void)thn_setHomeSceneUserInfoData:(HomeSceneListRow *)userModel;

@end
