//
//  THNMessageTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNUserModelCounter.h"

@interface THNMessageTableViewCell : UITableViewCell

@pro_strong UIImageView *icon;
@pro_strong UILabel *title;
@pro_strong UILabel *countPop;
@pro_strong UIImageView *next;
@pro_strong UILabel *botLine;

- (void)thn_setMessageData:(NSInteger)index withCount:(THNUserModelCounter *)model;
- (void)thn_hiddenCountPop:(BOOL)isHidden;

@end
