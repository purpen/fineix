//
//  OtherCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo;

@interface OtherCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView *bgImageView;//背景图片
@property(nonatomic,strong) UIImageView *userHeadImageView;//用户的头像
@property(nonatomic,strong) UILabel *nickName;//用户昵称
@property(nonatomic,strong) UILabel *userProfile;//用户简介
@property(nonatomic,strong) UILabel *userLevelLabel;//用户等级文字
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *moreBtn;//更多按钮
@property(nonatomic,strong) UIButton *focusOnBtn;//关注按钮
@property(nonatomic,strong) UIButton *directMessages;//私信按钮

-(void)setUI;
@end
