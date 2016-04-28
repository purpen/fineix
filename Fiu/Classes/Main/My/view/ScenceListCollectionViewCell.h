//
//  ScenceListCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeSceneListRow;

@interface ScenceListCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView         *   bgImage;        //  场景图
@property(nonatomic,strong) UIView              *   userView;       //  用户信息视图
@property(nonatomic,strong) UIImageView         *   userHeader;     //  用户头像
@property(nonatomic,strong) UILabel             *   userName;       //  用户昵称
@property(nonatomic,strong) UILabel             *   userProfile;    //  用户简介
@property(nonatomic,strong) UILabel             *   lookNum;        //  查看数量
@property(nonatomic,strong) UILabel             *   likeNum;        //  喜欢数量
@property(nonatomic,strong) UILabel             *   titleText;      //  标题文字
@property(nonatomic,strong) UILabel             *   whereScene;     //  所属情景
@property(nonatomic,strong) UILabel             *   city;           //  城市
@property(nonatomic,strong) UILabel             *   time;           //  时间

- (void)setUIWithModel:(HomeSceneListRow*)model;
@end
