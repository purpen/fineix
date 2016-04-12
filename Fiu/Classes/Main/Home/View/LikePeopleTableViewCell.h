//
//  LikePeopleTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface LikePeopleTableViewCell : UITableViewCell

@pro_strong UIButton        *   morePeopel;     //  查看更多用户
@pro_assign CGFloat             cellHeight;

- (void)setUI;

- (void)getCellHeight:(NSArray *)people;

@end
