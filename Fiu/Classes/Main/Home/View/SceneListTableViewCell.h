//
//  SceneListTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface SceneListTableViewCell : UITableViewCell

@pro_strong UIImageView         *   bgImage;        //  场景图
@pro_strong UIView              *   userView;       //  用户信息视图

@pro_strong UIImageView         *   userHeader;     //  用户头像
@pro_strong UILabel             *   userName;       //  用户昵称
@pro_strong UILabel             *   userProfile;    //  用户简介
@pro_strong UILabel             *   lookNum;        //  查看数量
@pro_strong UILabel             *   likeNum;        //  喜欢数量
@pro_strong UILabel             *   titleText;      //  标题文字
@pro_strong UILabel             *   whereScene;     //  所属情景
@pro_strong UILabel             *   city;           //  城市
@pro_strong UILabel             *   time;           //  时间

- (void)setUI;

@end
