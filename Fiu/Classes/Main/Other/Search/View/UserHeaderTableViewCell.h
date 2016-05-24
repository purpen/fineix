//
//  UserHeaderTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface UserHeaderTableViewCell : UITableViewCell

@pro_strong UIButton            *       userHeader;      //  用户头像
@pro_strong UILabel             *       userName;           //  用户昵称
@pro_strong UILabel             *       userProfile;        //  用户简介
@pro_strong UIButton            *       concernBtn;         //  关注按钮
@pro_strong UILabel             *       line;               //  分割线

- (void)setUI;

@end
