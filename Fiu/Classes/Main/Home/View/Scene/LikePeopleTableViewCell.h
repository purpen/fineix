//
//  LikePeopleTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "LikeOrSuPeopleRow.h"
#import "UIButton+WebCache.h"

@interface LikePeopleTableViewCell : UITableViewCell

@pro_strong UINavigationController      *   nav;
@pro_strong UIButton                    *   morePeopel;     //  查看更多用户
@pro_strong NSMutableArray              *   imgMarr;        //  用户头像
@pro_strong NSMutableArray              *   userIdMarr;     //  用户id
@pro_assign CGFloat                         cellHeight;

- (void)setLikeOrSuPeopleData:(NSMutableArray *)model;

- (void)getCellHeight:(NSArray *)people;

@end
