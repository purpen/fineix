//
//  FiuPeopleListTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/7/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "FiuPeopleListRow.h"

@interface FiuPeopleListTableViewCell : UITableViewCell

@pro_strong UIButton            *   firstImg;       //  排行1、2、3名奖牌图
@pro_strong UILabel             *   numLab;         //  排名
@pro_strong UIImageView         *   userHeader;     //  用户头像
@pro_strong UILabel             *   userName;       //  用户昵称
@pro_strong UIImageView         *   userVimg;       //  加V
@pro_strong UILabel             *   userStar;       //  认证信息
@pro_strong UILabel             *   userProfile;    //  用户简介
@pro_strong UILabel             *   userLevel;      //  用户等级

- (void)setFiuPeopleListData:(NSInteger)num withData:(FiuPeopleListRow *)model;

@end
