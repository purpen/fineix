//
//  ScenceListCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeSceneListRow;
#import "FBUserTagsLable.h"

@interface ScenceListCollectionViewCell : UICollectionViewCell
@pro_strong UIImageView         *   bgImage;        //  场景图
@pro_strong UIView              *   userView;       //  用户信息视图
@pro_strong UIImageView         *   userHeader;     //  用户头像
@pro_strong UIImageView         *   userVimg;       //  加V
//@pro_strong FBUserTagsLable     *   userStar;       //  认证信息
@pro_strong UILabel             *   userStar;       //  认证信息
@pro_strong UILabel             *   userName;       //  用户昵称
@pro_strong UILabel             *   userProfile;    //  用户简介
@pro_strong UILabel             *   lookNum;        //  查看数量
@pro_strong UILabel             *   likeNum;        //  喜欢数量
@pro_strong UILabel             *   titleText;      //  标题文字
@pro_strong UILabel             *   whereScene;     //  所属情景
@pro_strong UILabel             *   city;           //  城市
@pro_strong UILabel             *   time;           //  时间
@pro_strong NSMutableArray      *   tagDataMarr;
@pro_strong NSMutableArray      *   userTagMarr;

- (void)setHomeSceneListData:(HomeSceneListRow *)model;
@end
