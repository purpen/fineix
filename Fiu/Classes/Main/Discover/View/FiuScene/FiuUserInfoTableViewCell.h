//
//  FIiuUserInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "FiuSceneInfoData.h"

@interface FiuUserInfoTableViewCell : UITableViewCell

@pro_strong UINavigationController  *   nav;

@pro_strong UIImageView         *   bgImage;        //  场景图
@pro_strong UIView              *   userView;       //  用户信息视图
@pro_strong UIView              *   userLeftView;   //  背景右
@pro_strong UIButton            *   userHeader;     //  用户头像
@pro_strong UILabel             *   userName;       //  用户昵称
@pro_strong UILabel             *   userProfile;    //  用户简介
@pro_strong UIView              *   userRightView;  //  背景左
@pro_strong UIButton            *   goodBtn;        //  订阅按钮
@pro_strong UILabel             *   goodNum;        //  订阅数量
@pro_strong UILabel             *   titleText;      //  标题文字
@pro_strong UILabel             *   city;           //  城市
@pro_strong UILabel             *   time;           //  时间
@pro_strong NSString            *   userId;

- (void)setFiuSceneInfoData:(FiuSceneInfoData *)model;

@end
